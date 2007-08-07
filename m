Return-Path: <linux-kernel-owner+w=401wt.eu-S934275AbXHGNSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934275AbXHGNSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 09:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761586AbXHGNSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 09:18:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:51615 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760437AbXHGNSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 09:18:30 -0400
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX18WaZlNU5YWWQdbcbWVtRa3zGsyMZDcOB7GQjeGtt
	M0NcpEV/ReRUp5
From: Dimitrios Apostolou <jimis@gmx.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: high system cpu load during intense disk i/o
Date: Tue, 7 Aug 2007 16:15:43 +0300
User-Agent: KMail/1.9.7
Cc: =?utf-8?q?Rafa=C5=82_Bilski?= <rafalbilski@interia.pl>,
       linux-kernel@vger.kernel.org
References: <200708031903.10063.jimis@gmx.net> <46B7BF67.8010506@gmx.net> <20070807013708.406a22fd@the-village.bc.nu>
In-Reply-To: <20070807013708.406a22fd@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708071615.44452.jimis@gmx.net>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 August 2007 03:37:08 Alan Cox wrote:
> > > acpi_pm_read is capable of disappearing into  SMM traps which will make
> > > it look very slow.
> >
> > what is an SMM trap? I googled a bit but didn't get it...
>
> One of the less documented bits of the PC architecture. It is possible to
> arrange that the CPU jumps into a special mode when triggered by some
> specific external event. Originally this was used for stuff like APM and
> power management but some laptops use it for stuff like faking the
> keyboard interface and the Geode uses it for tons of stuff.
>
> As SMM mode is basically invisible to the OS what oprofile and friends
> see isn't what really occurs. So you see
>
> 	pci write -> some address
>
> you don't then see
>
> 	SMM
> 	CPU saves processor state
> 	Lots of code runs (eg i2c polling the battery)
> 	code executes RSM
>
> 	Back to the OS
>
> and the next visible profile point. This can make an I/O operation look
> really slow even if it isn't the I/O which is slow.

I always thought x86 is becoming a really dirty architecture. I now think it 
is even uglier. :-p Thank you for the thorough explanation. 

>
> > the reason I'm talking about a "software driver limit" is because I am
> > sure about some facts:
> > - The disks can reach very high speeds (60 MB/s on other systems with
> > udma5)
>
> Is UDMA5 being selected firstly ?

What the kernel selects by default is udma4 (66MB/s). I tried forcing udma5 
(100MB/s) with hdparm even though I think my chipset doesn't support it, and 
indeed there was a difference! After repetitive tests udma4 gives 20MB/s, 
udma5 gives 22MB/s. I'm mostly surprised however that I could even set this 
option.

>
> > So what is left? Probably only the corresponding kernel module.
>
> Unlikely to be the disk driver as that really hasn't changed tuning for a
> very long time. I/O scheduler interactions are however very possible.

I'm now trying to use the new libata driver and see what happens... 


Thanks, 
Dimitris
