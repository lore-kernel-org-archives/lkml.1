Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbYKPJfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbYKPJfr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 04:35:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbYKPJfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 04:35:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:36040 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbYKPJfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 04:35:37 -0500
Date: Sun, 16 Nov 2008 01:36:20 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Bernhard Walle <bwalle@suse.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 2/2] Add dev.mem.restricted sysctl
Message-ID: <20081116013620.5564de1e@infradead.org>
In-Reply-To: <20081116103005.72a28833@kopernikus.site>
References: <1226793823-32360-1-git-send-email-bwalle@suse.de>
	<1226793823-32360-3-git-send-email-bwalle@suse.de>
	<20081115194914.6791b96c@infradead.org>
	<20081116103005.72a28833@kopernikus.site>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2008 10:30:05 +0100
Bernhard Walle <bwalle@suse.de> wrote:

> * Arjan van de Ven [2008-11-15 19:49]:
> >
> > On Sun, 16 Nov 2008 01:03:43 +0100
> > Bernhard Walle <bwalle@suse.de> wrote:
> > 
> > > When CONFIG_STRICT_DEVMEM is set, live debugging is not possible
> > > with the crash utility (see http://people.redhat.com/~anderson).
> > > For distributors who ship a generic kernel it's difficult:
> > > Disabling CONFIG_STRICT_DEVMEM is possible, but in general the
> > > protection provided by CONFIG_STRICT_DEVMEM is useful. However,
> > > live debugging should be still neceessary.
> > > 
> > > This patch now adds a dev.mem.restricted sysctl that defaults to 0
> > > (off). When set to 1 (on), /dev/mem access is unrestricted and
> > > crash can be used.
> > 
> > sounds like a really bad idea to me.
> > If you want to use /dev/mem like this, don't enable the config
> > option to restrict it. Really.
> 
> So, what's that restriction really for? 

It's for not allowing something that you don't need, if you 
know you don't need it. Least privilege and all that.
(so that selinux can give X access to devices but not to all of memory.
I know Alan mentioned DMA but that's also a choice, a lot of the systems
on the market for the last year or two have an IOMMU that you can use
etc)
 
But if you do need it, then you do need it, simple as that.

(that leave the entire fun question of cache attributes but thats' a
whole different animal)

 
-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
