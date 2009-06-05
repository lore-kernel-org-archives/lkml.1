Return-Path: <linux-kernel-owner+w=401wt.eu-S1751699AbZFETrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699AbZFETrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 15:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbZFETrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 15:47:24 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:45070 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbZFETrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 15:47:23 -0400
Date: Fri, 5 Jun 2009 21:49:38 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jon Masters <jonathan@jonmasters.org>
Cc: balbir@linux.vnet.ibm.com,
       Robert Berger <robert.berger@reliableembeddedsystems.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: http://patchwork.kernel.org/patch/26483/ broke my system boot
Message-ID: <20090605194938.GA23195@uranus.ravnborg.org>
References: <20090603143944.GF29326@balbir.in.ibm.com> <20090603194526.GG3100@uranus.ravnborg.org> <20090604063144.GB7504@balbir.in.ibm.com> <1244186233.11597.106.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244186233.11597.106.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 03:17:12AM -0400, Jon Masters wrote:
> On Thu, 2009-06-04 at 14:31 +0800, Balbir Singh wrote:
> > * Sam Ravnborg <sam@ravnborg.org> [2009-06-03 21:45:26]:
> > 
> > > On Wed, Jun 03, 2009 at 10:39:44PM +0800, Balbir Singh wrote:
> > > > After spending some time figuring out why my system failed to reboot,
> > > > checking config options, kernel version, modules installed. I figured
> > > > out that the patch in http://patchwork.kernel.org/patch/26483/ broke
> > > > the system boot on the latest mmotm. Reverting it helped my system
> > > > call depmod and hence boot.
> > > > 
> > > > The patch is really unhelpful, since the changelog is completely
> > > > empty. Sigh!
> > > 
> > > Yeah, sorry for not nak'ing it earlier. Has been busy.
> > > Andrew removed it from -mm and I notified the author about the
> > > problems with the patch (in private mail it seems - I just replied to what I had).
> > 
> > Cool! Thanks for the update. I'll get the latest mmotm and test as
> > well.
> 
> The general idea of using the cross-depmod is good though :) We have had
> a few people recently run their newer host depmod and wonder why their
> older embedded device can't read the new binary index files.

But then the patch would lok like this - no?

index 610d1c3..05c5744 100644
--- a/Makefile
+++ b/Makefile
@@ -325,7 +325,8 @@ OBJCOPY             = $(CROSS_COMPILE)objcopy
 OBJDUMP                = $(CROSS_COMPILE)objdump
 AWK            = awk
 GENKSYMS       = scripts/genksyms/genksyms
-DEPMOD         = /sbin/depmod
+DEPMOD         = $(if $(shell which $(CROSS_COMPILE)depmod),
+                       $(CROSS_COMPILE)depmod,/sbin/depmod)
 KALLSYMS       = scripts/kallsyms
 PERL           = perl
 CHECK          = sparse


	Sam
