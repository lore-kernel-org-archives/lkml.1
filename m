Return-Path: <linux-kernel-owner+w=401wt.eu-S1761546AbXFDTXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761546AbXFDTXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758829AbXFDTX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:23:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39324 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799AbXFDTXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:23:25 -0400
Date: Mon, 4 Jun 2007 21:23:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't the kernel realize the BIOS has problems and re-map appropriately?
Message-ID: <20070604192323.GA14844@one.firstfloor.org>
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan> <200706011407.51779.jbarnes@virtuousgeek.org> <20070601211943.GO7217@one.firstfloor.org> <200706011441.57149.jbarnes@virtuousgeek.org> <m1r6orwptz.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0706041420100.25811@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706041420100.25811@p34.internal.lan>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From their e-mail:
> 
> Note before continuing: Debian* Linux Operating System is not an 
> officially, validated, tested Operating System for the Intel(R) Desktop 
> Board DG965WH 
> (see http://downloadcenter.intel.com/Product_Filter.aspx?ProductID=2375); 
> moreover, we do confirm that "on a system that has 8 GB of system memory 
> installed, it is not possible to use all of the installed memory due to 
> system address space being allocated for other system critical functions." 
> [qtd. on page 43 of the Technical Product Specification (see 
> http://download.intel.com/design/motherbd/wh/D5600801US.pdf)].  Thus, the
> following suggestions are provided AS IS; we cannot guarantee the problem 
> would be fixed afterwards:

They're talking about something different than your issue. If you put in
the fully possible 8GB (4x2GB) then some memory will be lost to the PCI hole
because the desktop ICH can only access 35bits (8GB) in hardware.

That can be up to 2GB in extreme cases, usually <0.5-1GB depending
on how much mapping space your hardware needs.

But if you put in less than 8GB the BIOS is supposed to remap 
the memory around the PCI hole and set up the MTRRs correctly
so that the PCI hole is uncached and the memory around it is cached.

That is 100% the BIOS' responsibility and if it doesn't do that
it is buggy.

-Andi
 
