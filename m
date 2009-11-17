Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbZKQAjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbZKQAjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 19:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbZKQAjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 19:39:39 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:33284 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbZKQAji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 19:39:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lGN07T3YfsGkalcr/r23IjQwcJGzKHjN8z+k8J3vIB1i55/zzd+zGmk/3RtbfDcRYY
         m8shqERkCpkygIrD8M0Q/T6z7l1BYSu3ChB6f+1I9py9xf+5AiSD6EI1F6eUF7c7dI+z
         m9lJStP1z++DvKsHO/WQfIrxogo0pHQIBbbzQ=
Message-ID: <4B01F0F8.4040807@gmail.com>
Date: Mon, 16 Nov 2009 16:40:24 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #14487] PANIC: early exception 08 rip 246:10 error ffffffff810251b5
 cr2 0
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera> <xXQGFmujPl.A.CnG.JTdALB@chimera>
In-Reply-To: <xXQGFmujPl.A.CnG.JTdALB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14487
> Subject		: PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2 0
> Submitter	: Justin P. Mattock<justinmattock@gmail.com>
> Date		: 2009-10-23 16:45 (25 days old)
> References	: http://lkml.org/lkml/2009/10/23/252
>
>
>
>    
This one has me a bit dazed i.g. after looking into the issue
I did find a workaround(keep in mind it's not pretty),
by commenting out set_fixmap_nocache and
init_ohci1394_reset_and_init_dma.
(by doing so I was able to load both machines and
execute early debugging in case  a problem occurs).

Now as to what might  be happening, after going through as
much as I can comprehend the only thing in mind was
reading fixmap.h the comments are stating that vsyscalls
only covers 32bit, and that there needs to be another set
for 64, leading me to believe that this is what I might be hitting.
(my system is pure64, taking in no 32bit at all).

At this point I think I need somebody to give me some info on this,
and if the 64bit issue mentioned above is the case, then we can probably
close this and leave it up to the x86_64 builders to create a 64bit
call for this whenever they get to it.(main thing is I'm able to
run dma early in case of an emergency).

Justin P. Mattock

