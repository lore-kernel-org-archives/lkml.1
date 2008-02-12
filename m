Return-Path: <linux-kernel-owner+w=401wt.eu-S1761240AbYBLBPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761240AbYBLBPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 20:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbYBLBPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 20:15:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34020 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbYBLBPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 20:15:30 -0500
Message-ID: <47B0EEAB.60904@zytor.com>
Date: Mon, 11 Feb 2008 16:56:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Konrad Rzeszutek <konrad@darnok.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       michaelc@cs.wisc.edu, dwm@enoyolf.org, darnok@68k.org,
       pjones@redhat.com, konradr@redhat.com, konradr@linux.vnet.ibm.com,
       randy.dunlap@oracle.com, lenb@kernel.org, mike.anderson@us.ibm.com,
       dwm@austin.ibm.com, arjan@infradead.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: REPOST: [PATCH] Add iSCSI iBFT support (v0.4.7)
References: <20080208194717.GA10712@andromeda.dapyr.net> <20080209031026.GA14878@andromeda.dapyr.net> <1202535132.3102.107.camel@localhost.localdomain> <200802111835.18172.konrad@darnok.org> <20080212004512.GA23636@kroah.com>
In-Reply-To: <20080212004512.GA23636@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Feb 11, 2008 at 06:35:16PM -0500, Konrad Rzeszutek wrote:
>>>> +       if (hdr->id == id_nic) {
>>>> +               pci_dev = pci_get_bus_and_slot((nic->pci_bdf & 0xff00) >>
>>>> 8, +                                              (nic->pci_bdf & 0xff));
>>> pci_get_bus_and_slot fails in the presence of PCI domains, which are
>>> getting to be fairly common even in medium sized servers ... what
>>> happens in that case?
>> The specification did not take that in to account. The Bus/Dev/Func 
>> information is only present there - no domain information.
> 
> That's really broken then.  Common i386 boxes these days have multiple
> PCI domains, it's not all that uncommon at all.
> 
> And almost all big 64 bit boxes have them.

Yes, but common x86 boxes can't *boot* from anything but domain 0 (in 
particular, the domain which the cf8/cfc registers on the boot processor 
activate.)

	-hpa
