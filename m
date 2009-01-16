Return-Path: <linux-kernel-owner+w=401wt.eu-S936428AbZAPTCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936428AbZAPTCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 14:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756481AbZAPTCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 14:02:19 -0500
Received: from smtp-out.google.com ([216.239.33.17]:50157 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172AbZAPTCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 14:02:18 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=MFZzvkD2WFBfxg8gTGy42+p3nfcoLXjnSAjTHqeq0eRtJ0mSZa+P3MjutZLErdk+z
	CYBCWYxuhrK0D4i5jtvSg==
MIME-Version: 1.0
In-Reply-To: <20090116090928.e43c986e.akpm@linux-foundation.org>
References: <1232117771.3224.21.camel@localhost.localdomain>
	 <20090116090928.e43c986e.akpm@linux-foundation.org>
Date: Fri, 16 Jan 2009 11:02:12 -0800
Message-ID: <da824cf30901161102r67b9c31euc12fc95fb8330a07@mail.gmail.com>
Subject: Re: [GIT PATCH] firs round of SCSI bug fixes for 2.6.29-rc1
From: Grant Grundler <grundler@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.148
X-GMailtapped: grundler
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 9:09 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
...
>> +             CHIPREG_WRITE32(&ioc->chip->Doorbell, 0xC0FFEE00);
>> +             panic("%s: Firmware is halted due to command timeout\n",
>> +                     ioc->name);
>> +     }
>> +}
>> +EXPORT_SYMBOL(mpt_halt_firmware);
>
> Doing a panic() after we've already detected an error is plain nasty.
> Is there no way in which we can allow the kernel to continue?

Basically what James said. It's not long though: only 6 emails.
I started that thread thinking the same thing you did:
    http://marc.info/?t=123123569200003&r=1&w=2

TBH, I still wouldn't implement it the way LSI maintainers did.
I'm happy they are the maintainers and it's their call.

grant
