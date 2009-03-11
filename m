Return-Path: <linux-kernel-owner+w=401wt.eu-S1753682AbZCKVE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbZCKVE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 17:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbZCKVEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 17:04:11 -0400
Received: from smtp10.mail.tnz.yahoo.co.jp ([203.216.226.138]:46363 "HELO
	smtp10.mail.tnz.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752592AbZCKVEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 17:04:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=yj20050223; d=yahoo.co.jp;
  h=Received:X-Apparently-From:Message-ID:From:To:Cc:References:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:X-MSMail-Priority:X-Mailer:X-MimeOLE;
  b=I9LHo8BKwwkv7CcUwXTM2UcqwLaRqGXn/+XzF7aa4oywNk1dA3OshcOdt3QvU5zOKsB45vBCRaBM8nUc0/f+Lp4uc2ALCIhI/H3o1b2c/zqG+161imzJivGLZNOJZ2kY  ;
X-Apparently-From: <n0diamond@yahoo.co.jp>
Message-ID: <065A106FBB5F41B18A030BD2C87570FA@DIAMOND8600>
From: "Norman Diamond" <n0diamond@yahoo.co.jp>
To: "Sergei Shtylyov" <sshtylyov@ru.mvista.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
       "Norman Diamond" <n0diamond@yahoo.co.jp>
References: <20090311032805.3120.qmail@web4114.mail.ogk.yahoo.co.jp> <49B78859.5050807@ru.mvista.com>
Subject: Re: Off-by-one in both LIBATA and IDE drivers
Date: Thu, 12 Mar 2009 06:03:33 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-2022-jp";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
> Norman Diamond wrote:
>> [attribution stolen:]
>>> [Norman Diamond:]
>>>> It looks like both LIBATA and the old IDE drivers
>>>> have an off-by-one error in deciding whether to use
>>>> READ SECTOR(S) instead of READ SECTOR(S) EXT.
>>>>
>>> This was fixed here:
>>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=97b697a11b07e2ebfa69c488132596cc5eb24119
>>
>> Thank you.
>> I will see if I can port that fix to 2.6.24.3, because
>> Slax 6.0.3 and kernel 2.6.24.3 avoided some other bugs of
>> later kernels.
>
> Note that this doesn't fix it for the IDE core.

That helps explain my subsequent testing.  I'm still having problems.

> The ide-disk driver however seems to use LBA48 regardless of the sector 
> address.

But that doesn't explain my subsequent testing.  That behaviour would cause 
it to work in one of my present cases, but it still fails.

> But still there are incorrect capacity checks, and it can fails with 
> drivers not supporting LBA48 with DMA...

Yeah that could be part of it.  2.6.20 turned on DMA more often than later 
kernels, so I'm now thinking of reverting to 2.6.20.  I've heard (but 
couldn't test personally) that 2.6.20 gave abysmal performance to users of 
AMD chipsets.  Since Intel users outnumber them, I'm inclined to revert to a 
version that worked for Intel even though AMD suffers. 

--------------------------------------
Power up the Internet with Yahoo! Toolbar.
http://pr.mail.yahoo.co.jp/toolbar/
