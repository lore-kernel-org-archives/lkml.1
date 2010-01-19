Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574Ab0ASCEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab0ASCEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 21:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098Ab0ASCEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 21:04:10 -0500
Received: from mail-iw0-f197.google.com ([209.85.223.197]:53588 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab0ASCEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 21:04:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MnZhLxV9aRHqXL2cuhauzGbHqmGJwveRTHNPckqX/+bddHernMPOwfDLUOZnEpcStV
         dvSSupho49BF7shvoE2ocgV/kM+Ab9ra/vipjIQXVU8jXtZHF4gjMOHKO1FnbjmrDqXH
         HkfhtDC69WyyjTwXG4lCAPcSroa6oA1nVmqk8=
Message-ID: <4B55130D.8070503@gmail.com>
Date: Mon, 18 Jan 2010 20:03:57 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Subject: Re: MSI broken in libata?
References: <64bb37e0912250122n4e0e1842q88c0dad7e99ec6a7@mail.gmail.com>	 <4B484829.6060405@kernel.org>	 <64bb37e1001092033r1f0b4defw46c1a07101bb2d1b@mail.gmail.com>	 <4B4A7BC7.6060106@kernel.org> <4B4A815A.60503@gmail.com>	 <64bb37e1001161358r79ea2da0u88e9894fa5987ef1@mail.gmail.com>	 <4B536383.7090609@gmail.com>	 <64bb37e1001171311u21c58fbj9a13b6aaeb7b2c3f@mail.gmail.com> <64bb37e1001181251y733513cdm1be9850af880ee73@mail.gmail.com>
In-Reply-To: <64bb37e1001181251y733513cdm1be9850af880ee73@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2010 02:51 PM, Torsten Kaiser wrote:
> On Sun, Jan 17, 2010 at 10:11 PM, Torsten Kaiser
> <just.for.lkml@googlemail.com>  wrote:
>> What was different between -rc4 and my earlier tests was, that there
>> where additional error messages from do_IRQ.
>
>> [  112.382903] do_IRQ: 0.165 No irq handler for vector (irq -1)
>> [  112.382923] do_IRQ: 3.165 No irq handler for vector (irq -1)
>> [  112.382939] do_IRQ: 1.165 No irq handler for vector (irq -1)
>> [  112.382957] do_IRQ: 2.165 No irq handler for vector (irq -1)
>> [  143.010051] ata2.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x6 frozen
>> [  143.010060] ata2.00: failed command: READ FPDMA QUEUED
>> [  143.010071] ata2.00: cmd 60/00:00:ad:71:d9/01:00:01:00:00/40 tag 0
>> ncq 131072 in
>> [  143.010073]          res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask
>> 0x4 (timeout)
>> [  143.010079] ata2.00: status: { DRDY }
>> [  143.010083] ata2.00: failed command: READ FPDMA QUEUED
>> [  143.010092] ata2.00: cmd 60/00:08:ad:70:d9/01:00:01:00:00/40 tag 1
>> ncq 131072 in
>> [  143.010095]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
>> 0x4 (timeout)
>> [  143.010099] ata2.00: status: { DRDY }
>> [  143.010108] ata2: hard resetting link
>
>> I will look, if I can find out, where the do_IRQ error comes from and
>> why I didn't see it with -rc1 to -rc3.
>
> OK, this has nothing to do with -rc3 vs. -rc4.
> If I kill the drive with reading a 1GB file with dd, I get the above
> errors, include the one from do_IRQ.
> If I kill the drive with writing a 1GB file with dd, I do not get the
> do_IRQ error.
> As I tested the earlier -rcs only with writes, I didn't see it there.
> (Its not even in the old logs that contain the libata errors)
>
> Should I try to put some printks in arch/x86/kernel/apic/io_apic.c
> __assign_irq_vector() or is there a better way to look at the irq
> vectors?

Might not be a bad idea. Something definitely seems to be banging on 
vector 165. Any references to 165 in dmesg prior to that? I wonder where 
that is coming from..
