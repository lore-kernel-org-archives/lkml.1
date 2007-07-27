Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbXG0EXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbXG0EXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 00:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbXG0EXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 00:23:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33817 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751031AbXG0EXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 00:23:03 -0400
Date: Thu, 26 Jul 2007 21:22:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alan Curry <pacman@theworld.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] powerpc: Pegasos keyboard detection
Message-Id: <20070726212241.032e9755.akpm@linux-foundation.org>
In-Reply-To: <1185505222.5495.182.camel@localhost.localdomain>
References: <200707250128.l6P1SWSF1336935@shell01.TheWorld.com>
	<1185347565.5439.310.camel@localhost.localdomain>
	<20070726184800.0bb3b9fb.akpm@linux-foundation.org>
	<1185505222.5495.182.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007 13:00:21 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Thu, 2007-07-26 at 18:48 -0700, Andrew Morton wrote:
> > On Wed, 25 Jul 2007 17:12:45 +1000 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> > 
> > > On Tue, 2007-07-24 at 21:28 -0400, Alan Curry wrote:
> > > > As of 2.6.22 the kernel doesn't recognize the i8042 keyboard/mouse controller
> > > > on the PegasosPPC. This is because of a feature/bug in the OF device tree:
> > > > the "device_type" attribute is an empty string instead of "8042" as the
> > > > kernel expects. This patch (against 2.6.22.1) adds a secondary detection
> > > > which looks for a device whose *name* is "8042" if there is no device whose
> > > > *type* is "8042".
> > > > 
> > > > Signed-off-by: Alan Curry <pacman@world.std.com>
> > > 
> > > Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > > 
> > > Note, if there's a volunteer, we could probably turn that code into a
> > > nice table lookup.
> > 
> > Did this get merged, or otherwise fixed?  Even though the code in there has
> > changed quite a bit, it looks to my untrained eye like the fix is still
> > applicable?
> 
> Merged a fixed version:
> 
> f5d834fc34e61f1a40435981062000e5d2b2baa8
> 
> (In linus tree as of now)

I hope so.  Alan's patch looks rather different from what you have now:
fall back to of_find_node_by_name() if of_find_node_by_type() failed.

