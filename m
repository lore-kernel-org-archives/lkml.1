Return-Path: <linux-kernel-owner+w=401wt.eu-S1755040AbYANRGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbYANRGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 12:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbYANRGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 12:06:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50263 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbYANRGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 12:06:01 -0500
Date: Mon, 14 Jan 2008 18:08:56 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <andi@firstfloor.org>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: unify pagetable accessors patch causes double fault II
Message-ID: <20080114170856.GA18412@one.firstfloor.org>
References: <20080114094814.GA28300@basil.nowhere.org> <20080114125638.GA9510@basil.nowhere.org> <20080114130620.GA14057@elte.hu> <20080114135811.GA16190@one.firstfloor.org> <478B9183.3020101@goop.org> <20080114165635.GK15542@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114165635.GK15542@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> would be nice to have some debugging apparatus for bugs like this. 
> Perhaps artificially add a large pfn, then convert/unconvert, then 
> subtract it and expect the whole transformation to be an identity 
> mapping? This way we could simulate most of the effects of >4GB RAM, 
> right?

If you want to really test it regularly hacking KVM or Xen or Qemu 
to supply large virtual addresses is probably better. Long ago we
tested with a special BIOS that always put some memory high up
the map.

But then Addresses >3GB are pretty common now because a lot of people put in
2 2 GB DIMMs into systems (2GB DIMMs are not really that expensive anymore). 
And with memory hole remapping you get suitable large addresses then. So
it should be tested often enough.

On the other hand the whole area was always subtly broken. I yesterday 
finally tracked down 

ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/pgtable-nx

which was broken forever. What an embarassing bug :/

-Andi

