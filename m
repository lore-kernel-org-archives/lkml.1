Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbZLAAPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbZLAAPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 19:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbZLAAPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 19:15:41 -0500
Received: from complete.lackof.org ([198.49.126.79]:36205 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbZLAAPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 19:15:41 -0500
Date: Mon, 30 Nov 2009 17:15:44 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Alex Williamson <alex.williamson@hp.com>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: Always set prefetchable base/limit upper32
	registers
Message-ID: <20091201001544.GE24539@lackof.org>
References: <20091130212228.7555.43533.stgit@debian.lart> <4B143AE5.7040702@kernel.org> <1259617381.8949.281.camel@8530w.home> <4B143E83.6020105@kernel.org> <1259618496.8949.290.camel@8530w.home> <4B144346.50608@kernel.org> <1259619578.8949.295.camel@8530w.home> <4B1455FD.90002@kernel.org> <20091201000049.GC24539@lackof.org> <4B145EAF.8030909@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B145EAF.8030909@kernel.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 04:09:19PM -0800, Yinghai Lu wrote:
> Grant Grundler wrote:
> > On Mon, Nov 30, 2009 at 03:32:13PM -0800, Yinghai Lu wrote:
> >> IORESOURCE_MEM_64 get set when PCI_PREF_RANGE_TYPE_64 is set.
> > 
> > PCI_PREF_RANGE_TYPE_64 is when we read BARs. It doesn't indicate
> > anything about PCI Bridge Window registers AFAIK.
> > 
> 
> please double check pci-to-pci bridge 1.2, in page 47.

My apologies. You are correct:
    The bottom 4 bits of both the Prefetchable Memory Base and
    Prefetchable Memory Limit registers are read-only, contain
    the same value, and encode whether or not the bridge supports
    64-bit addresses. If these four bits have the value 0h, then
    the bridge supports only 32 bit addresses. If these four bits
    have the value 01h, then the bridge supports 64-bit addresses
    and the Prefetchable Base Upper 32 Bits and Prefetchable Limit
    Upper 32 Bits registers hold the rest of the 64-bit prefetchable
    base and limit addresses respectively.

thanks,
grant
