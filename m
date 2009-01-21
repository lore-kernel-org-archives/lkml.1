Return-Path: <linux-kernel-owner+w=401wt.eu-S1762960AbZAUAfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762960AbZAUAfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 19:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757371AbZAUAfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 19:35:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48625 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756875AbZAUAfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 19:35:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: [PATCH PCI PCIe portdrv: Fix allocation of interrupts (rev. 5)
Date: Wed, 21 Jan 2009 01:16:08 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200901131457.58164.rjw@sisk.pl> <4973F60E.5000706@jp.fujitsu.com> <49744142.2060806@jp.fujitsu.com>
In-Reply-To: <49744142.2060806@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901210116.09211.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 January 2009, Kenji Kaneshige wrote:
> Hidetoshi Seto wrote:
> > Rafael J. Wysocki wrote:
> >> On Saturday 17 January 2009, Rafael J. Wysocki wrote:
> > (snip)
> >>> If MSI-X are supported, it allocates as many vectors as there are entries
> >>> in the port's MSI-X table, but no more than 32, and figures out which of them
> >>> will be used for the port services.
> >> The patch didn't check which services are available during the MSI-X set up
> >> which was wrong.
> >>
> >> Also, in the meantime, i thought it might be a good idea to free the interrupt
> >> routing table entries that aren't going to be used after all.
> >>
> >> The patch below adds this to the previous version and checks for the
> >> availability of port services in the MSI-X setup resume.  I hope it will
> >> be acceptable to everyone.
> >>
[--snip--]
> > 
> > /* Are there any unused entries? */
> > if (nr_allocated > nvec) {
> > 	/* this port have extra entries not for services we know... */
> > 
> 
> Sounds good. That is,
> 
> If the number of entries we required equals to nr_entries (from
> Table size field in Message Control register), we don't need to
> drop the first MSI-X setup.

I've split the patch into two parts, one adding pci_msix_table_size() and the
other containing the rest of changes.  Also, I've modified the second patch to
follow the above observation.

The patches will follow as replies to this message.

Thanks,
Rafael

