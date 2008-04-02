Return-Path: <linux-kernel-owner+w=401wt.eu-S1758952AbYDBTtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952AbYDBTtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 15:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758201AbYDBTtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 15:49:39 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:60121 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757632AbYDBTtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 15:49:39 -0400
Date: Wed, 2 Apr 2008 15:49:38 -0400
To: Frans Pop <elendil@planet.nl>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
Message-ID: <20080402194938.GI24237@csclub.uwaterloo.ca>
References: <200804021524.27222.elendil@planet.nl> <200804021629.41153.elendil@planet.nl> <20080402154636.GH24237@csclub.uwaterloo.ca> <200804021820.04610.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804021820.04610.elendil@planet.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 06:20:03PM +0200, Frans Pop wrote:
> Well, what the installer used to do for Sarge and Etch was basically to load 
> _all_ drivers (including ide-generic) manually by default, which is totally 
> useless as most devices are perfectly autodetected nowadays. It also wastes 
> memory as you'd end up having a lot of unused drivers in memory.
> 
> Post-etch we decided to change that and currently drivers are only loaded if 
> autodetected (with some exceptions, such as for sparc sbus and hppa bus). 
> We were aware that this could cause some regressions, but so far this is the 
> first real report.
> 
> Another change in Debian since Etch is that initramfs-tools no longer loads 
> ide-generic by default, which IMO is also a good thing. We can easily make 
> it load ide-generic when needed, but for that again we first have to know 
> that it _is_ needed.

Well, my educated guess (and that's all it is) is that any system with a
386, 486 or pentium might have an ISA based IDE controller.  For that
matter I used to have an ISA based IDE controller on my sound card in a
PPro, although that one was PnP capable (although I always ran with that
disabled because it sucked).

Essentially if you have an ISA bus there could be an IDE controller
there.  No way to really know without probing the standard IDE ports,
which is pretty much what ide-generic does as far as I can tell.  I
think many architectures other than x86 also have generic IDE
controllers that are supported as long as ide-generic is loaded with the
architecture specific code having defined the ports to look at.

> Yes, that could be one way to implement it: load it and then check if that 
> added any devices.

Well even if you see other disks doesn't mean you don't also have an old
IDE controller you want to use, so probably load it and see if it finds
any disks is the best bet after loading all the other probeable drivers
first.

> That would still leave us with the problem of not knowing whether it needs 
> to be added for initramfs-tools or not.
> 
> If there are no other suggestions, I guess we'll go with a "load and check" 
> implementation. Thanks a lot for your input.

I think that's the best you can do.

> Anybody know how other distributions deal with this?

I gave up other distributions for Debian in 1999, so I can't help there.

-- 
Len Sorensen
