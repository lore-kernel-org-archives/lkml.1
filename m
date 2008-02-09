Return-Path: <linux-kernel-owner+w=401wt.eu-S1754663AbYBIFcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbYBIFcb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 00:32:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbYBIFcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 00:32:22 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42095 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002AbYBIFcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 00:32:21 -0500
Subject: Re: REPOST: [PATCH] Add iSCSI iBFT support (v0.4.7)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Konrad Rzeszutek <konrad@darnok.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, michaelc@cs.wisc.edu, dwm@enoyolf.org,
       darnok@68k.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com, randy.dunlap@oracle.com, hpa@zytor.com,
       lenb@kernel.org, mike.anderson@us.ibm.com, dwm@austin.ibm.com,
       arjan@infradead.org, Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <20080209031026.GA14878@andromeda.dapyr.net>
References: <20080208194717.GA10712@andromeda.dapyr.net>
	 <20080209031026.GA14878@andromeda.dapyr.net>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 23:32:12 -0600
Message-Id: <1202535132.3102.107.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-08 at 23:10 -0400, Konrad Rzeszutek wrote:
> +       if (hdr->id == id_nic) {
> +               pci_dev = pci_get_bus_and_slot((nic->pci_bdf & 0xff00) >> 8,
> +                                              (nic->pci_bdf & 0xff));
> +               if (pci_dev) {
> +                       rc = sysfs_create_link(&ibft_kobj->kobj,
> +                                              &pci_dev->dev.kobj, "device");
> +                       pci_dev_put(pci_dev);
> +               }

pci_get_bus_and_slot fails in the presence of PCI domains, which are
getting to be fairly common even in medium sized servers ... what
happens in that case?

James


