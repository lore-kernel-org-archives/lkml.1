Return-Path: <linux-kernel-owner+w=401wt.eu-S1761180AbYBKXiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761180AbYBKXiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 18:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756147AbYBKXiC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 18:38:02 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:40180 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbYBKXiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 18:38:00 -0500
From: Konrad Rzeszutek <konrad@darnok.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: REPOST: [PATCH] Add iSCSI iBFT support (v0.4.7)
Date: Mon, 11 Feb 2008 18:35:16 -0500
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, michaelc@cs.wisc.edu, dwm@enoyolf.org,
       darnok@68k.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com, randy.dunlap@oracle.com, hpa@zytor.com,
       lenb@kernel.org, mike.anderson@us.ibm.com, dwm@austin.ibm.com,
       arjan@infradead.org, Andy Whitcroft <apw@shadowen.org>
References: <20080208194717.GA10712@andromeda.dapyr.net> <20080209031026.GA14878@andromeda.dapyr.net> <1202535132.3102.107.camel@localhost.localdomain>
In-Reply-To: <1202535132.3102.107.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802111835.18172.konrad@darnok.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +       if (hdr->id == id_nic) {
> > +               pci_dev = pci_get_bus_and_slot((nic->pci_bdf & 0xff00) >>
> > 8, +                                              (nic->pci_bdf & 0xff));
> pci_get_bus_and_slot fails in the presence of PCI domains, which are
> getting to be fairly common even in medium sized servers ... what
> happens in that case?

The specification did not take that in to account. The Bus/Dev/Func 
information is only present there - no domain information.

Do you think I should implement a search functionality for this so that is 
searches through the domains for the bus/dev/func and picks the 
first found match (which might be the wrong match)? Or wait to get the spec
updated so that the iBFT will have this data?
