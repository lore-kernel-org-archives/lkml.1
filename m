Return-Path: <linux-kernel-owner+w=401wt.eu-S1751954AbXBERUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbXBERUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 12:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbXBERUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 12:20:54 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:61247 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbXBERUw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 12:20:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NV8OlOjTqqMnnM7FBritkMx7uSJwOcemKqBxV4rmSlSEaPycSpwHPQDFT3f6Wmz7PGPPL+KO/+E3nUt+awZdqGF5iLW11cH+qYzca9E+GYISt+0CMGd2gAqDmPfIuVYMKtmkkPWOkpNs09ugWSUcFOaZQWp7X1esqWfcYJpNbEg=
Message-ID: <1a297b360702050920v76fd61b6qb958c6223cba5442@mail.gmail.com>
Date: Mon, 5 Feb 2007 21:20:49 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Luming Yu" <luming.yu@gmail.com>
Subject: Re: 2.6.20 PCI Cannot allocate resource region 2
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       greg@kroah.com, "Andrew Morton" <akpm@osdl.org>
In-Reply-To: <3877989d0702041904w1b57bb1dufbb731d2823d0b64@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1a297b360702041709l3b0309c7y8fcd33df1d487889@mail.gmail.com>
	 <3877989d0702041904w1b57bb1dufbb731d2823d0b64@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/5/07, Luming Yu <luming.yu@gmail.com> wrote:
> On 2/5/07, Manu Abraham <abraham.manu@gmail.com> wrote:
> > Hi,
> >
> > I get this error on booting up 2.6.20 (Similar error on 2.6.17.7 also,
> > the message is slightly different in 2.6.17.7)
> >
> > PCI Cannot allocate resource region 2 of device 0000:02:0a.0
> Just did a search about this message around the kernel source tree.
> The interesting thing is that I see the following comments at several
> different arch/drivers files. Is it related to your problem?
>
>  *  Known BIOS problems we have to work around:
>  *      - I/O or memory regions not configured
>  *      - regions configured, but not enabled in the command register
>  *      - bogus I/O addresses above 64K used
>   *      - expansion ROMs left enabled (this may sound harmless, but given
>   *        the fact the PCI specs explicitly allow address decoders to be
>   *        shared between expansion ROMs and other resource regions, it's
>  *        at least dangerous)
>

The card supports I/O addresses above 64k, i think. It has a PCMCIA
slot as well on it, allowing access to the same

I have put my dmesg over here http://kromtek.com/dvb/dmesg.txt It
looks like lot of workarounds in my BIOS to me probably, couldn't
really make out much in there

The bridge features from the vendor are like this ..

PCI 2.2 Compatible
DVB Common Interface EN50221 Compliant
Philips I2C 2.0 Compliant
Master mode
UART – RS232
Receiver mode
Support PTC PT2225
TSMC 0.25um 5M1P CMOS Technology
PQFP 144 Package

2.5V Core / 3.3V IO
2660x2560 um2
100K Gate
4 Clock Domains
99.6% ATPG Test Coverage
32 scan chains

Implementation
Logical
Logic synthesis – Synopsys 2003.12-SP1
Test synthesis – Synopsys DFTC 2003.12-SP1
Physical
P&R – Synopsys Astro 2003.06-SP2

Verification
Logical
Simulation – Cadence NCsim 5.1
Physical
DRC/LVS – Synopsys Hercules 2003.12


DVB Common Interface EN50221 Compliant
Memory Mode
CIS
Support 8/16 bit
IO Mode
Indirect Read/Write
Issue address and data thru PCI local register
Pseudo GPIO Pins
A12/A13/A14

Common Access (CA)
Card reader – 7816 compliant
DVB CSA / B-CAS Multi2
PID/session filters

UART
Receiver mode only – 6 bits data
Configurable BAUD rate
9600 to 115.2K
16 Word FIFO
I2C
Master mode only
400k/s default



One of the things that really confused me was, on 2.6.17.7 in lspci it
always shows BIST is running. on 2.6.20, it is not there at all.

If this is a bug in the BIOS, i am wondering how the older revisions
of the same bridge works. The last two devices in that lspci output
are Rev 01 devices


Regards,
Manu
