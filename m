Return-Path: <linux-kernel-owner+w=401wt.eu-S1757204AbYFIT2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204AbYFIT2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 15:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbYFIT2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 15:28:43 -0400
Received: from paoakoavas09.cable.comcast.com ([208.17.35.58]:1197 "EHLO
	paoakoavas09.cable.comcast.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753889AbYFIT2n convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 15:28:43 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jun 2008 15:28:42 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: Can Linux control PCIe Transaction Layer Packet creation, when writing to a region pointed to by Base Address Register 
Date: Mon, 9 Jun 2008 12:13:21 -0700
Message-ID: <38F5F6E4D905F142BAA734B9D894F12407634DB1@CAPLSEXCMB01.cable.comcast.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Can Linux control PCIe Transaction Layer Packet creation, when writing to a region pointed to by Base Address Register 
Thread-Index: AcjKYx4kphc7TNNoQSeRJ99NvJf1hgAAWrIA
From: "Meyers, Jordan" <Jordan_Meyers@cable.comcast.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 09 Jun 2008 19:13:24.0003 (UTC) FILETIME=[E35B9730:01C8CA64]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


     During the process of writing a PCIe device driver, I observed an interesting phenomenon with respect to Transaction Layer Packet (TLP) generation.  The device driver needs to transfer upwards of 1/3 KB in the payload of a single TLP.  I used the pci_iomap function combined with memcpy_toio for data transfer to the address space pointed to by a Base Address Register (BAR).  When I used the memcpy_toio, the buffer content I tried to write was split into dword (4B) sized pieces and each dword was given its own TLP.  According to PCI-SIG and some of the research I've done, the PCIe Bus Controller is responsible for this behavior.  The PCIe Bus Controller turns the driver accesses into TLPs.  This presents an interesting problem.  Since the generation of these TLPs (from the BAR region) are out of the hands of the Operating System, what procedure can a driver go through to ensure that all the data makes it into a single TLP payload.  One thought I had was the use of DMA buffers, and having the PCIe card pull the data from the DMA buffer.  I observed the DMA pushes from the card to the buffer, were not subject to the same limiting factors.  
     All the observations I made were done by using a Lecroy PCIe analyzer.  The machine I ran this on was a Dell Precision 490 (which had 2 AMD quad core, x86_64 architecture).  I've tested the behavior on SUSE Linux running kernel 2.6.16 and 2.6.22.  And the chipset was Intel 5000x ( the relevant PCIe component of the chipset is the 6321 ESB I/O Hub Controller).

     Any thoughts or suggestions of how to ensure a buffer's data is transferred from the driver to the PCIe card in a single TLP (where the intended payload size is less than the max payload value in Device Control register of the PCI register space)?  Thank you to everyone who has taken the time to read this post. 

Jordan Meyers
