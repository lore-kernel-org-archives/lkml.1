Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbZLVTQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbZLVTQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 14:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbZLVTQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 14:16:18 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:51481 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799AbZLVTQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 14:16:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iFfET1H8MhS5rhuS1KoOKgmujc2XLRnntXjGqIor40VTI9Xc/TRDHNXcrlnzgt/zOd
         MTv/2jZRfg7iTnCvdmIIl1u1jsbOwH3fjKhPLCG5SLIEbVgOLtKROXT6LyAp9Ia7EL25
         9rSAWyeenvCtVrjlvGH7wjqkGPrylJH4qtbaI=
MIME-Version: 1.0
In-Reply-To: <1261502431.4937.38.camel@laptop>
References: <74fd948d0912220851v354b1704xa55fc3c88e1c300c@mail.gmail.com>
	 <1261502431.4937.38.camel@laptop>
Date: Tue, 22 Dec 2009 19:16:16 +0000
Message-ID: <74fd948d0912221116l477a8a71w1feadc1341fc6e21@mail.gmail.com>
Subject: Re: WARN_ON at line 380 in kernel/smp.c under 2.6.32.2 + TuxOnIce + 
	KDB
From: Pedro Ribeiro <pedrib@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22, 2009 at 5:20 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2009-12-22 at 16:51 +0000, Pedro Ribeiro wrote:
>> Hi all,
>>
>> I've been asked by Nigel Cunningham of TuxOnIce to forward this bug here.
>>
>> While resuming from hibernate (using TuxOnIce) I'm seeing the WARN_ON
>> at line 380 in kernel/smp.c trigger from a kmap_high call right after
>> secondary processors have been brought down (the previous message is
>> "CPU1 is down").
>>
>> I only have pictures of the backtrace (readable but not very good
>> quality, sorry).
>> http://img51.imageshack.us/img51/2312/stacktrace1.jpg
>> http://img195.imageshack.us/img195/3646/stacktrace2.jpg
>>
>> At first I thought this was related to my battery saving script
>> messing with /proc/sys/vm/dirty_writeback_centisecs, but I'm not sure
>> right now, it still happens with the default value, so I'm clueless.
>>
>> Mind you, this does not impede the resume - it just dumps this stack
>> trace and continues resuming happily.
>
> If you'd enable frame pointers the strack traces would be clearer, but
> it looks like a bug in tux on ice, doing kmap_high() with IRQs disabled
> or something like that.
>
>

Thanks for your reply.

I enabled frame pointers, is this more useful?
http://img684.imageshack.us/img684/5118/dsc01206m.jpg
http://img96.imageshack.us/img96/5493/dsc01207k.jpg
http://img33.imageshack.us/img33/7470/dsc01208lp.jpg

Regards,
Pedro
