Return-Path: <linux-kernel-owner+w=401wt.eu-S934082AbXGRSot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082AbXGRSot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbXGRSom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:44:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55812 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbXGRSom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:44:42 -0400
Date: Wed, 18 Jul 2007 20:44:40 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Jonathan Campbell <jon@nerdgrounds.com>, linux-kernel@vger.kernel.org,
       torvalds@transmeta.com
Subject: Re: Patches for REALLY TINY 386 kernels
Message-ID: <20070718184440.GD3898@one.firstfloor.org>
References: <469A8AED.7070207@nerdgrounds.com> <p737ioyxwyq.fsf@bingen.suse.de> <469E3806.4030804@zytor.com> <20070718183359.GK3801@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070718183359.GK3801@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 08:33:59PM +0200, Adrian Bunk wrote:
> On Wed, Jul 18, 2007 at 08:55:50AM -0700, H. Peter Anvin wrote:
> > Andi Kleen wrote:
> > > 
> > >> Already with these patches I can compile a zImage kernel that is 450kb
> > >> large (890kb decompressed)
> > > 
> > > The important part is not how big the vmlinux is, but how much
> > > memory is actually used after boot. 
> > > 
> > > I expect concentrating some of the dynamic data structures would
> > > be more fruitful in fact.
> > > 
> > 
> > Well, how big the vmlinux file is matters if it doesn't fit in memory
> > with enough time to get to the phase where it is dumping the init
> > sections.  *If that is not the issue*, then axing stuff like CPUID is a
> > major lose in terms of code maintainability for zero gain.
> 
> If this is an issue, then changing i386 back to discarding __exit code 

I don't think there is very much __exit code around in general.
e.g. a fairly fat x86-64 kernel here has a little over 5K.

> and data at linktime instead of runtime might make a bigger difference.

The problem is we would need separate exception tables for this then
or teach binutils about not warning. Hardly worth it for 5K.

In general it's more useful to focus on the real memory pigs 
(and measure first who they are) if you want to save memory. 
See also http://www.halobates.de/memorywaste.pdf

-Andi
