Return-Path: <linux-kernel-owner+w=401wt.eu-S1755686AbZEZNXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbZEZNXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 09:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbZEZNWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 09:22:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35786 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755280AbZEZNWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 09:22:50 -0400
Date: Tue, 26 May 2009 14:23:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: linux-pci@vger.kernel.org, Greg KH <greg@kroah.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, towerlexa@gmx.de
Subject: Re: Who's responsible for configuring CLS on a cardbus device?
Message-ID: <20090526142300.73d466d0@lxorguk.ukuu.org.uk>
In-Reply-To: <4A1BE904.8080302@kernel.org>
References: <4A1BE904.8080302@kernel.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009 22:05:08 +0900
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> This is regarding bko#13257.
> 
>  http://bugzilla.kernel.org/show_bug.cgi?id=13257
> 
> towerlexa@gmx.de was experiencing very slow transfer rate when using a
> cardbus sata_sil SATA controller which is known to be sensitive to
> cache line size setting.  The reset default is zero and no one
> configured it causing poor performance.
> 
> This is solvable by simply setting CLS to the correct value but who's
> job is it?  For non-hotplug devices, this is configured by the BIOS
> (at least on PC), so for hotplug devices I think falls on the lap of
> the PCI code but I'm not sure.  If this is something which the
> sata_sil driver should be responsible for, is there an established way
> to determine the proper CLS value?

Currently its handled by pci_set_mwi() but there isn't actually a more
direct way to do this.

Alan
