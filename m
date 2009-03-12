Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbZCLLVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbZCLLVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 07:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753616AbZCLLVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 07:21:22 -0400
Received: from smtp08.mail.tnz.yahoo.co.jp ([203.216.226.136]:48532 "HELO
	smtp08.mail.tnz.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753527AbZCLLVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 07:21:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=yj20050223; d=yahoo.co.jp;
  h=Received:X-Apparently-From:Message-ID:From:To:Cc:References:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:X-MSMail-Priority:X-Mailer:X-MimeOLE;
  b=tM0BdB5r6Q5RwQ/EA0SsSA2CK1xm8DmgWkwCaW5ZXc3uErJkPLeEkYp+5duco0glYJxCxUOaLsOOt5W8iWxzk/gRHWTM16R+0ZsfKeFZtsVl++bMKPyeQ6Uon3MPD5xM  ;
X-Apparently-From: <n0diamond@yahoo.co.jp>
Message-ID: <9CEE6A51B15649D3ABEBD9BE0241A345@DIAMOND8600>
From: "Norman Diamond" <n0diamond@yahoo.co.jp>
To: "Jim Paris" <jim@jtan.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
       "Robert Hancock" <hancockrwd@gmail.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Sergei Shtylyov" <sshtylyov@ru.mvista.com>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Norman Diamond" <n0diamond@yahoo.co.jp>
References: <20090311015039.42922.qmail@web4115.mail.ogk.yahoo.co.jp> <20090311030340.GA617@psychosis.jim.sh>
Subject: Re: Off-by-one in both LIBATA and IDE drivers
Date: Thu, 12 Mar 2009 20:20:48 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Paris wrote:
> Norman Diamond wrote:
>>
>> It looks like both LIBATA and the old IDE drivers have an off-by-one 
>> error in deciding whether to use READ SECTOR(S) instead of READ SECTOR(S) 
>> EXT.
>
> This was fixed here:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=97b697a11b07e2ebfa69c488132596cc5eb24119

I'm still having trouble after applying the same patch to 2.6.24.3 (applying 
it three times in order to build Slax).  But now I wonder if it's no longer 
the fault of drivers.

Does hdparm construct its own taskfiles for ATA and SATA in order to produce 
an error trying to read sector number 0x0fffffff even after I patched the 
kernel?

If dd works then did I adequately patch the kernel?

Meanwhile I think the kernel needs more patches than ata.h.
(1)  libata-core.c contains a suspicious expression 1UL << 28.
(2)  sata_inic162x.c contains a suspicious expression 1 << 28. 

--------------------------------------
Power up the Internet with Yahoo! Toolbar.
http://pr.mail.yahoo.co.jp/toolbar/
