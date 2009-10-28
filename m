Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbZJ1D4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbZJ1D4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 23:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757267AbZJ1D4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 23:56:08 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:38490 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254AbZJ1D4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 23:56:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FSUW1Y0R3RO7Yf3tEsLIsRA2nVnCqBh+q7JmDOOrB24NKaQ9h2pWfxzDGls5UgVmkc
         29/RRu5rFzDaq8VwoVCAfZIlenhKbB2PwC86QLEQzPixUFk80l0GI/zWmXDz6K2kdokj
         43nI+SxxSga/SgIYoZES4/A5U9lVmjtfS+Y8w=
Message-ID: <4AE7C0DB.8070206@gmail.com>
Date: Tue, 27 Oct 2009 20:56:11 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2
 0
References: <4AE24009.4090408@gmail.com> <dd18b0c30910261134s76274dbbj9c1904e78c2b5a38@mail.gmail.com> <21504.1256588976@turing-police.cc.vt.edu> <4AE611B2.1030409@gmail.com> <29209.1256624599@turing-police.cc.vt.edu>            <4AE744F6.5050801@gmail.com> <22388.1256672113@turing-police.cc.vt.edu>
In-Reply-To: <22388.1256672113@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Tue, 27 Oct 2009 12:07:34 PDT, "Justin P. Mattock" said:
>
>    
>> The results are similar with the messages, except
>> with the curly's the system will panic the same as above
>> and not boot.
>>      
>
> As I expected - I explained why already.  And in fact, I intentionally did
> that, so that the *last* one of those added messages before your panic
> will output the info regarding the device that caused it (hacking around
> the panic would mean that you'd get a whole bunch of messages and not have
> an easy way to tell *which one* caused the now-bypassed issue...)
>
>    
>> (So I guess it was good to forget the curly's
>> to some extent).
>>      
>
> So out of curiosity, what did the messages actually *SAY*?  They should
> be pointing at the device that's giving your system indigestion, so it's
> useful to actually include the output (I didn't pull that printk format
> string out of thin air.. ;)
>
>    
So after looking around I managed to get the machine to boot
by commenting out(just to see) some calls in
init_ohci1394_controller

these are the ones:

set_fixmap_nocache(FIX_OHCI1394_BASE, ohci_base);

init_ohci1394_reset_and_init_dma(&ohci);


Then kind of isolating the issue I looked into
set_fixmap_nocache
Now looking at fixmap.h I see some comments about
x86_64 integration, leading me to believe maybe this is what/why
I'm hitting a panic.

Justin P. mattock




