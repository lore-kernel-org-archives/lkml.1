Return-Path: <linux-kernel-owner+w=401wt.eu-S1752962AbXFWG4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbXFWG4x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 02:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbXFWG4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 02:56:45 -0400
Received: from arx.rabbit.us ([68.251.127.6]:2080 "EHLO arx.rabbit.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbXFWG4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 02:56:44 -0400
Message-ID: <467CC429.3030505@rabbit.us>
Date: Sat, 23 Jun 2007 08:56:41 +0200
From: Peter Rabbitson <rabbit@rabbit.us>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070618)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       surenkarapetyan@gmail.com
Subject: Re: Terrible IO performance when using 4GB of RAM on a 32 bit machine
 [solved]
References: <fa.8+Qu4ZH2B8PP3bRaZ5LNdUcsFIQ@ifi.uio.no> <fa.X6rjOVHT6SoOzt6SHEJROeRgf98@ifi.uio.no> <fa.qwrQSldd4OzDT6RgWE5P1BD9PJw@ifi.uio.no> <467B1100.4000401@shaw.ca>
In-Reply-To: <467B1100.4000401@shaw.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Peter Rabbitson wrote:
>>
>> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
>> reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
>> reg02: base=0xc0000000 (3072MB), size= 512MB: write-back, count=1
>> reg03: base=0xe0000000 (3584MB), size= 256MB: write-back, count=1
>> reg04: base=0xf0000000 (3840MB), size= 128MB: write-back, count=1
>> reg05: base=0xf8000000 (3968MB), size=  32MB: write-back, count=1
> 
> Looks like another case of bad MTRRs on an Intel motherboard? The BIOS 
> is marking only memory up to 4000MB as cacheable, but the actual memory 
> extends up to about 4031MB. Therefore anything that accesses the top 
> 31MB of memory will run very slow.

I sincerely apologize for not paying enough attention. Intel has fixed 
this issue 2 BIOS revisions ago[1], kudos to Suren Karapetyan for 
pointing this out. I just upgraded the BIOS and it indeed solves the 
problem. The mtrr still seems not to be going over 4000MB, but 
everything works without any visible slowdowns at all. Here is how the 
mtrr and the relevant dmesg line look like now:

reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
reg02: base=0xc0000000 (3072MB), size= 512MB: write-back, count=1
reg03: base=0xe0000000 (3584MB), size= 256MB: write-back, count=1
reg04: base=0xf0000000 (3840MB), size= 128MB: write-back, count=1
(there is no reg05)
...
Memory: 4024568k/4063168k available (2894k kernel code, 37456k reserved, 
930k data, 252k init, 3145664k highmem)
...

Thank you for the help!

Peter

[1] 
http://downloadcenter.intel.com/Detail_Desc.aspx?agr=N&Inst=Yes&ProductID=1640&DwnldID=11261&strOSs=All&OSFullName=All%20Operating%20Systems&lang=eng
