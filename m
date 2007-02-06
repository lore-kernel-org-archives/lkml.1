Return-Path: <linux-kernel-owner+w=401wt.eu-S1751733AbXBFIsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733AbXBFIsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 03:48:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbXBFIsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 03:48:06 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:5365 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbXBFIsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 03:48:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aQvBJxYJiC5duH9NaShlLcHEN7mJZgJsarhWZzpQBwGLhtLqRGY0QHs7hYKKE3PpVPy/PZdThH5swHTueLgpnQQbQacmGLzsf//nvfuRaOmtwI/R1qjaeMEY6rZgZZqby2w837ZrQVBosLCWQPfmXlNFY9InPtB2DpHf0ldr3/c=
Message-ID: <1a297b360702060048t1e6e4e90l1bf78400bcdf5c4c@mail.gmail.com>
Date: Tue, 6 Feb 2007 12:48:01 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Grant Grundler" <grundler@parisc-linux.org>
Subject: Re: 2.6.20 PCI Cannot allocate resource region 2
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       greg@kroah.com, "Andrew Morton" <akpm@osdl.org>
In-Reply-To: <20070206082550.GA25953@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1a297b360702041709l3b0309c7y8fcd33df1d487889@mail.gmail.com>
	 <20070206045528.GA4228@colo.lackof.org>
	 <1a297b360702052120x10f15b4cicaa867573d0210b9@mail.gmail.com>
	 <20070206082550.GA25953@colo.lackof.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/6/07, Grant Grundler <grundler@parisc-linux.org> wrote:
> On Tue, Feb 06, 2007 at 09:20:15AM +0400, Manu Abraham wrote:
> ...
> > >BIST is required to complete in 2 seconds. Either with success or failure.
> > >I expect BIOS to have complained before launching grub/lilo.
> ...
> > BIST is supposed to terminate before, say the OS kernel is loaded?
>
> Yes - that's what I was trying to imply above.
>
> > or does it mean that it can keep running still ?
>
> Don't know. Either it's still running (for much longer that 2 seconds),
> linux is causing it run _again_, or linux is has terribly confused the
> device somehow. More on this in an email I'm still working on...will
> send that out in a bit.

i think probably, Linux is causing it to run again .. ?


> > >>       Region 0: Memory at f7ee0000 (32-bit, non-prefetchable) [disabled]
> > >[size=4K]
> > >>       Region 2: Memory at e9b00000 (32-bit, prefetchable) [disabled]
> > >[size=4K]
> > >>       Region 3: Memory at <unassigned> (32-bit, prefetchable) [disabled]
> > >>       Region 4: Memory at <ignored> (32-bit, non-prefetchable) [disabled]
> > >>       Region 5: Memory at <invalid-64bit-slot> (64-bit,
> > >non-prefetchable) [disabled]
> > >
> > >This is obviously garbage. 64-bit registers can only be represented with
> > >two consecutive "BAR" and region 5 is the last one.
> > >There is no way this can be a 64-bit BAR.
> > >Generally, 64-bit BARs start on an "even" numbered BAR (but I've forgotten
> > >again if that's just convention or a requirement)
> > >
> >
> > was just wondering how it could be a 64 bit device.
>
> 64-bit BAR is seperate from 64-bit Device (data path).
>
> PCI has three different 32 vs 64-bit areas:
> o BARs
> o DMA
> o HW/data path width.
>
> "32-bit device" generally only refers to the latter.
> The three attributes are generally all "32-bit" for "32-bit device".


According to the information i have on this device ..

Configuration Register 00H : Device_ID / Vendor_ID Register
Bit [31:16] R Device_ID Device ID = 16'h4e35
Bit [15:0] R Vendor_ID Vendor ID = 16'h1822

Configuration Register 04H : Status / Command Register
Bit 31 R Detpar_rpt Detect Parity Report
Bit 30 W/R System_err Indicate System Error
Bit 29 R Master_abort Indicate Master Abort
Bit 28 R Target_abort Indicate Target Abort
Bit [27:25] Default = 3'b001
Bit 24 R Datapar_rpt Data Parity Report
Bit [23:20] Default = 4'b0000
Bit [19:16] Default = 4'b0000
Bit [15:9] Default = 7'h0
Bit 8 W/R Pci_serr_en PCI system error enable
Bit 7 Default = 1'b0
Bit 6 W/R Pci_perr_en PCI parity error enable
Bit [5:3] Default = 3'h0
Bit 2 W/R Pci_master_en PCI master mode enable
Bit 1 W/R Pci_target_en PCI target mode enable
Bit 0 Default = 1'b0

Configuration Register 08H : Class_Code / Revision_ID Register
Bit [31:8] R Class_Code Class_Code = 24'h048000
Bit [7:0] R Revision_ID Revision_ID = 8'h01

Configuration Register 0CH : Latency Timer Register
Bit [31:16] Default = 16'h0
Bit [15:11] W/R Pci_lat_timer Indicate PCI latency timer
Bit [10:8] Default = 3'h0
Bit [7:0] Default = 8'b0

Configuration Register 10H : Base_Address / Memory&Prep Register
Bit [31:12] W/R Pci_base_addr Indicate PCI Base Address
Bit [31:0] R Default = 12'h008

Configuration Register 2CH : I2C Subsystem_ID / Subsystem_Vendor_ID Register
Bit [31:0] W/R I2c_ssid_ssvid Indicate I2C subsystem_ID / subsystem_vendor_ID

Configuration Register 38H : Test PCI Connection Register
Bit [31:0] W/R Test_pci_conn Indicate to test PCI connection

Configuration Register 3CH : Max_Latency / Min_Gnt / Int_Pin / Int_Line Register
Bit [31:24] W Max_lat Default = 8'hFF
Bit [23:16] W Min_gnt Default = 8'h08
Bit [15:8] W Int_pin Default = 8'h01
Bit [7:0] W/R Int_line Indicate interrupt line



> That's less likely to be true for "64-bit devices". Several "64-bit
> devices" can only DMA to 32-bit host memory and at least a few only
> support 32-bit BARs (even if the device claims it has a 64-bit BAR).
>


AFAIK, the device does 32 bit DMA, but it is not completely hardware driven DMA.
it just uses a RISC core which just jumps to the pointer allocated in software.

The other devices using the same chip, works that way.

> hth,
> grant


thanks,
manu
