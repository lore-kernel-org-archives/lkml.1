Return-Path: <linux-kernel-owner+w=401wt.eu-S1757622AbXI1GTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbXI1GTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 02:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbXI1GTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 02:19:41 -0400
Received: from web51401.mail.re2.yahoo.com ([206.190.38.180]:29871 "HELO
	web51401.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754258AbXI1GTk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 02:19:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Lg71oU6NcKziy0zU+UE8r59qKB0qzPs2yDxgy5klaqtyOiu4aYeg6l/HZSao2KIe6Xt3c0CBK+5ZwwylG2zU167KsJyb37HCYczDAV36C/Xd3vZttEjARThZwuUDmGUjmXTBM91ac8gVIgufzqibnLMUlAqmU8vRaRGbVpdFiGo=;
X-YMail-OSG: ITIXLmgVM1k.Lzk45jCUo4hFF4oVZHJdmTqSjtnO1ts8PFTyOgGAY3r_D5wIDhNA3cXREsIyyWpLx4AyOrR2_lEmvU1H86fCKXVWuhHcF8.dgF8LJMbqaj9emTkaPOZcp3jO8uDwJbM5r6gUosgwaIZToA--
X-Mailer: YahooMailRC/651.50 YahooMailWebService/0.7.134
Date: Thu, 27 Sep 2007 23:19:39 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: AW: More E820 brokenness
To: Jordan Crouse <jordan.crouse@amd.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: jkeating@redhat.com, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <125549.77407.qm@web51401.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,
I won't be able to test anything before next Tuesday, but I'm with
Jordan on this one. Have a look at the dmsg output I sent you some
time ago (http://article.gmane.org/gmane.linux.kernel/584681).

This was as plain from Linus' tree as you get it (git bisect, make defconfig, make)
and I see:
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001e7b0000 (usable)
 BIOS-e820: 000000001e7b0000 - 000000001e7bffc0 (ACPI data)
 BIOS-e820: 000000001e7bffc0 - 000000001e7c0000 (ACPI NVS)
 BIOS-e820: 0000000040400000 - 0000000040440004 (reserved)
 BIOS-e820: 00000000f0000000 - 0000000100000000 (reserved) --  
Kind regards
 
       Joerg
 


----- Ursprüngliche Mail ----
Von: Jordan Crouse <jordan.crouse@amd.com>
An: H. Peter Anvin <hpa@zytor.com>
CC: jkeating@redhat.com; Joerg Pommnitz <pommnitz@yahoo.com>; Chuck Ebbert <cebbert@redhat.com>; Linux Kernel Mailing List <linux-kernel@vger.kernel.org>; Andi Kleen <ak@suse.de>
Gesendet: Freitag, den 28. September 2007, 01:15:52 Uhr
Betreff: Re: More E820 brokenness

On 27/09/07 15:47 -0700, H. Peter Anvin wrote:
> Jordan Crouse wrote:
> > 
> > Breaks on the Geode - original behavior.
> > 
> > I think that having boot_prams.e820_entries != 0 makes the kernel
> > assume the e820 data is correct.
> > 
> 
> Okay, now I'm utterly baffled how 2.6.22 ever worked on this Geode,
> because this, to the best of my reading, mimics the 2.6.22 behavior
> exactly.  DID IT REALLY, and/or did you make any kind of configuration
> changes?

I copied in a 2.6.22 kernel to see that it really did work, and it did.
But here's the crazy part - I did a dmesg, and it looks like it
*is* using e820 data, and it looks complete (I see the entire map - 
including the ACPI and reserved blocks way up high).

So apparently it was the 2.6.22 code that was buggy, but reading it,
I don't immediately see how. 

Jordan
-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.








      __________________________________  
Yahoo! Clever: Sie haben Fragen? Yahoo! Nutzer antworten Ihnen. www.yahoo.de/clever

