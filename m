Return-Path: <linux-kernel-owner+w=401wt.eu-S1761258AbZCSUnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761258AbZCSUnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756582AbZCSUnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:43:37 -0400
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:54373 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757979AbZCSUng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:43:36 -0400
Date: Thu, 19 Mar 2009 13:43:34 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Alex Chiang <achiang@hp.com>
cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 08/12] PCI: Introduce /sys/bus/pci/devices/.../remove
In-Reply-To: <20090319164119.GC8074@ldl.fc.hp.com>
Message-ID: <Pine.LNX.4.58.0903191342120.28292@shell2.speakeasy.net>
References: <20090318222426.887.1008.stgit@bob.kio> <20090318224006.887.91805.stgit@bob.kio>
 <49C2540E.70207@jp.fujitsu.com> <20090319164119.GC8074@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Mar 2009, Alex Chiang wrote:
> * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> >> +	pci_remove_bus_device(pdev);
> >> +	if (bridge && list_empty(&pdev->bus->devices))
> >> +		pci_remove_bus(pdev->bus);
> >
> > I cannot understand the above two lines. Could you explain
> > what it intend?
>
> If the user says:
>
> 	echo 1 > /sys/bus/pci/devices/.../remove
>
> And that device is a bridge, then we need to specifically call
> pci_remove_bus as well, to actually remove the bus itself.
> Without it, pci_bus_remove_device() will remove all of its
> children (and subordinate buses) in a depth-first manner, but we
> will never actually remove the bus that the user specified.

Did this end up being the source of the pci resource assignment warnings
that were produced when re-adding a bridge that was removed?
