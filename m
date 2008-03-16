Return-Path: <linux-kernel-owner+w=401wt.eu-S1754179AbYCPWPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbYCPWPK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 18:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbYCPWO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 18:14:59 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:57017 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbYCPWO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 18:14:58 -0400
Date: Sun, 16 Mar 2008 15:14:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Rob Landley <rob@landley.net>
Cc: Greg KH <gregkh@suse.de>, Samuel Masham <samuel.masham@gmail.com>,
       stable@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24.3 broke "make headers_install".
Message-Id: <20080316151426.4b4baf09.randy.dunlap@oracle.com>
In-Reply-To: <200803161709.52389.rob@landley.net>
References: <93564eb70802241736l741e7406o29fab05a611c12c7@mail.gmail.com>
	<93564eb70803101913n2ede72d1i33279772440c9afa@mail.gmail.com>
	<20080311033306.GB9198@suse.de>
	<200803161709.52389.rob@landley.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Mar 2008 17:09:51 -0500 Rob Landley wrote:

> On Monday 10 March 2008 22:33:06 Greg KH wrote:
> > On Tue, Mar 11, 2008 at 11:13:02AM +0900, Samuel Masham wrote:
> > > Hi Stable, Greg, all,
> > >
> > > Just a quick ping.
> > >
> > > Still not seeing these on the stable queue? Any issue or am i just
> > > looking in the wrong place:-
> > >
> > > http://www.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
> >
> > You're looking in the right place, I'm just slow these days :)
> >
> > thanks,
> >
> > greg k-h
> 
> Speaking of the stable queue, I just tried 2.6.24.3 and "make headers_install" 
> now dies with:
> 
> make[2]: *** No rule to make target 
> `/home/landley/firmware/firmware/build/temp-i686/linux/include/linux/if_addrlabel.h', 
> needed by 
> `/home/landley/firmware/firmware/build/cross-compiler-i686/include/linux/if_addrlabel.h'.  
> Stop.
> 
> I note that 2.6.24.2 didn't do that.
> 
> The problem seems t be this hunk:
> 
> diff -ru build.bak/sources/linux/include/linux/Kbuild 
> build/sources/linux/includ
> e/linux/Kbuild
> --- build.bak/sources/linux/include/linux/Kbuild        2008-02-10 
> 23:51:11.0000
> 00000 -0600
> +++ build/sources/linux/include/linux/Kbuild    2008-02-25 
> 18:20:20.000000000 -0
> 600
> @@ -217,6 +217,7 @@
>  unifdef-y += icmp.h
>  unifdef-y += icmpv6.h
>  unifdef-y += if_addr.h
> +unifdef-y += if_addrlabel.h
>  unifdef-y += if_arp.h
>  unifdef-y += if_bridge.h
>  unifdef-y += if_ec.h
> 
> The corresponding if_addrlabel.h file isn't in the 2.6.24.3 tarball, that I 
> can find...

Yes, it's been reported a few times already and should be fixed/reverted
in the next stable release.

---
~Randy
