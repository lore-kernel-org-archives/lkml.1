Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbZLAATk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbZLAATk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 19:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbZLAATi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 19:19:38 -0500
Received: from complete.lackof.org ([198.49.126.79]:46175 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbZLAATh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 19:19:37 -0500
Date: Mon, 30 Nov 2009 17:19:42 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Alex Williamson <alex.williamson@hp.com>, jbarnes@virtuousgeek.org,
       yinghai@kernel.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] PCI: Always set prefetchable base/limit upper32
	registers
Message-ID: <20091201001942.GF24539@lackof.org>
References: <20091130214954.10845.23072.stgit@debian.lart> <20091201000332.GD24539@lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091201000332.GD24539@lackof.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 05:03:32PM -0700, Grant Grundler wrote:
> On Mon, Nov 30, 2009 at 02:51:44PM -0700, Alex Williamson wrote:
> > Prior to 1f82de10 we always initialized the upper 32bits of the
> > prefetchable memory window, regardless of the address range used.
> > Now we only touch it for a >32bit address, which means the upper32
> > registers remain whatever the BIOS initialized them too.
> > 
> > It's valid for the BIOS to set the upper32 base/limit to
> > 0xffffffff/0x00000000, which makes us program prefetchable ranges
> > like 0xffffffffabc00000 - 0x00000000abc00000
> > 
> > Revert the chunk of 1f82de10 that made this conditional so we always
> > write the upper32 registers and remove now unused pref_mem64 variable.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@hp.com>
> 
> Reviewed-by: Grant Grundler <grundler@parisc-linux.org>

NAK this - I messed up. Yinghai is correct. Something else is going on.

It might be perfectly OK to read 0xffffffffabc00000 if the bridge
isn't using the upper32 Prefetchable register. Maybe the problem is
some code is reading the upper32 value without checking that it's valid?

grant
