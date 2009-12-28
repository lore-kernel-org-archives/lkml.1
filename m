Return-Path: <linux-kernel-owner+w=401wt.eu-S1751218AbZL1Srs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218AbZL1Srs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 13:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbZL1Srr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 13:47:47 -0500
Received: from outbound-mail-20.bluehost.com ([69.89.20.235]:53191 "HELO
	outbound-mail-20.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750961AbZL1Srq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 13:47:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=VRYoFrusle2zCr1yLTG7UHy1YBETjGLGE+V8t7z30/jMhIRRzTDnzFHteyGPjf6XCtVLid4ysf/5quaM79AjGc4ai1ltiG+QKj5m0rAsiV7isDChub5rvRximCwVZq9d;
Date: Mon, 28 Dec 2009 10:47:41 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: keithp@keithp.com, Daniel Vetter <daniel.vetter@ffwll.ch>,
       linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
       dri-devel@lists.sourceforge.net
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes
 when ..."
Message-ID: <20091228104741.7e5aa82a@jbarnes-x200>
In-Reply-To: <200912211757.08305.arnd@arndb.de>
References: <200912071830.14697.arnd@arndb.de>
	<20091217111359.54f4c518@jbarnes-piketon>
	<200912211606.43789.arnd@arndb.de>
	<200912211757.08305.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i586-moblin-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.118.45.122 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Dec 2009 17:57:08 +0000
Arnd Bergmann <arnd@arndb.de> wrote:

> On Monday 21 December 2009 16:06:43 Arnd Bergmann wrote:
> > 
> > -       if (IS_G4X(dev)) {
> > -               u16 gcfgc;
> > -
> > -               /* Adjust render clock... */
> > -               pci_read_config_word(dev->pdev, GCFGC, &gcfgc);
> > -
> > -               /* Down to minimum... */
> > -               gcfgc &= ~GM45_GC_RENDER_CLOCK_MASK;
> > -               gcfgc |= GM45_GC_RENDER_CLOCK_266_MHZ;
> > -
> > -               pci_write_config_word(dev->pdev, GCFGC, gcfgc);
> > -       } else if (IS_I965G(dev)) {
> > +       if (IS_I965G(dev)) {
> >                 u16 gcfgc;
> 
> This crashed again immediately, apparently because IS_I965G is a
> superset of IS_G4X (that seems counterintuitive), but not it seems to
> run using this modified version of the patch (half an hour so far).
> 

This code should be completely gone in Eric's drm-intel-next branch
(from
git://git.kernel.org/pub/scm/linux/kernel/git/anholt/drm-intel.git), so
hopefully when that lands upstream (if it hasn't already) things will
be solid for you.

Thanks,
Jesse
