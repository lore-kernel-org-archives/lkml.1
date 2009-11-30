Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbZK3X6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbZK3X6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 18:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbZK3X6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 18:58:35 -0500
Received: from complete.lackof.org ([198.49.126.79]:53588 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbZK3X6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 18:58:34 -0500
Date: Mon, 30 Nov 2009 16:58:38 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Alex Williamson <alex.williamson@hp.com>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: Always set prefetchable base/limit upper32
	registers
Message-ID: <20091130235838.GB24539@lackof.org>
References: <20091130212228.7555.43533.stgit@debian.lart> <4B143AE5.7040702@kernel.org> <1259617381.8949.281.camel@8530w.home> <4B143E83.6020105@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B143E83.6020105@kernel.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 01:52:03PM -0800, Yinghai Lu wrote:
> if HW state that reg is only 32bit pref,
> why should we care about the upper 32bit?

pref_mem64 describes the resource, not the HW.

All the PCI specs define Type 1 configuration space with Prefetchable Memory
register as 64-bit. Even if the Type 1 (PCI Bridge) HW ignores this register.
See "7.5.3. Type 1 Configuration Space Header" of PCI EXPRESS BASE
SPECIFICATION, REV. 1.1.

> looks like that your bridge device need quirk to clear that so called
> upper 32bit for it.

Hrm...I don't think this is a quirk. PCI spec defines 64-bit PrefMem
window register regardless of what type of resource we program into it.

hth,
grant
