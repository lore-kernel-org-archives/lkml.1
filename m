Return-Path: <linux-kernel-owner+w=401wt.eu-S1752331AbZHJTu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbZHJTu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 15:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbZHJTu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 15:50:58 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:35516 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZHJTu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 15:50:57 -0400
Date: Mon, 10 Aug 2009 21:50:48 +0200
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@gefanuc.com>
Cc: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 1/5] Staging: VME Framework for the Linux Kernel
Message-ID: <20090810195048.GB3055@braap.org>
References: <20090803205657.964064732@mini.kroah.org> <20090803210111.GB28430@kroah.com> <20090808230145.GB27151@braap.org> <4A801644.2070009@gefanuc.com> <20090810141442.GA18456@braap.org> <20090810153127.GB23319@braap.org> <4A804D67.4080308@gefanuc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A804D67.4080308@gefanuc.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martyn Welch wrote:
> If the driver writer wants a "single shot" effect, there's little  
> overhead in creating a one item link-list and executing it. However,  
> without support for this mode the author is stuck with single shot  
> transfers.  If the author wants to perform scatter gather type  
> transfers, without this functionality in the API - which is supported by  
> all the bridges I have seen - he won't be able to easily avail himself  
> of this functionality and get "work done".

Again, he (the driver writer) should know *nothing* about that.

As for the scatter-gather case, what should happen is:

User:		hey, there's a buffer I want to transfer. here's
		a pointer and size
VME layer:	ok, passing it to the bridge
VME bridge:	I know I'm over PCI, so I'll get the pages
		from memory and map the sg list over PCI, and
		then will tell the bridge to perform from there.

That's just a particular example, but for the user (read driver
writer) it's much simpler this way. Doesn't need to know about
lists or whatever.

E.
