Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbYLZW4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbYLZW4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 17:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbYLZW4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 17:56:15 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:38743 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbYLZW4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 17:56:14 -0500
Date: Fri, 26 Dec 2008 23:57:48 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Steve Brokenshire <sbrokenshire@xestia.co.uk>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Compress kernel modules on installation.
Message-ID: <20081226225748.GA25143@uranus.ravnborg.org>
References: <20080225214209.a3f79327.sbrokenshire@xestia.co.uk> <20080226112840.GA29465@uranus.ravnborg.org> <alpine.LSU.2.00.0812262026320.11203@fbirervta.pbzchgretzou.qr> <20081226194833.GA8306@uranus.ravnborg.org> <alpine.LSU.2.00.0812262049040.12031@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0812262049040.12031@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2008 at 08:50:34PM +0100, Jan Engelhardt wrote:
> 
> On Friday 2008-12-26 20:48, Sam Ravnborg wrote:
> >> >> 
> >> >> This patch allows kernel modules to be compressed when 'make
> >> >> modules_install' is run after being copied to
> >> >> the /lib/module/<version>/<...> directory which is useful if you have
> >> >> module-init-tools installed with --enable-zlib. This patch adds an
> >> >> option (MODULE_COMPRESS) to the kernel configuration file (specifically
> >> >> init/Kconfig) so that the kernel modules will compressed if
> >> >> MODULE_COMPRESS is set.
> >> 
> >> I recently started compressing my kernel modules and that saved me
> >> at least 70 MB of disk space on mostlyallmodconfig.
> >> (And no, the argument of disks being cheap is not so true with
> >> CF or SSD.)
> >> Distro is lazy and wants to wait for upstream to have it,
> >> so is there any chance of getting this proposal in?
> >
> >Steve said he wanted to try to make the solution more
> >scalable so I am awaiting a new patch.
> 
> Hm, all I needed was this patch. It might fire up some people,
> but it's got all the scalability I could think of..

Jan - there is obviously no way I could apply this patch
so late in the cycle. 
The original patch that made this a CONFIG option is
then much better as we avoid forcing new and untested
behaviour on the users.

We all know that compressing the modules are simple.
And unless someone comes up with *very* good arguments
then we should just use gzip with default parameters.

If we go for the "keep the .ko extension but compress"
then someone needs to answer the obvious questions:
- will this break on a typical distribution
- will this break busybox users

	Sam
