Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbZDFRa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbZDFRa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 13:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbZDFRaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 13:30:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57614 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbZDFRaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 13:30:11 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] drm: ignore LVDS on intel graphics systems that lie about having it
Date: Mon, 6 Apr 2009 13:29:53 -0400
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-170.2.56.fc10.x86_64; KDE/4.2.1; x86_64; ; )
Cc: dri-devel@lists.sourceforge.net, xorg-devel@lists.x.org,
       linux-kernel@vger.kernel.org, notting@redhat.com,
       Zhenyu Wang <zhenyu.z.wang@intel.com>,
       Fu Michael <michael_fu@linux.intel.com>
References: <200904061011.26389.jarod@redhat.com> <20090406095216.4361d128@hobbes>
In-Reply-To: <20090406095216.4361d128@hobbes>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904061329.53824.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 April 2009 12:52:16 Jesse Barnes wrote:
> On Mon, 6 Apr 2009 10:11:25 -0400
> Jarod Wilson <jarod@redhat.com> wrote:
> 
> > There are a number of small form factor desktop systems with Intel
> > mobile graphics chips that lie and say they have an LVDS. With kernel
> > mode-setting, this becomes a problem, and makes native resolution
> > boot go haywire -- for example, my Dell Studio Hybrid, hooked to a
> > 1920x1080 display claims to have a 1024x768 LVDS, and the resulting
> > graphical boot on the 1920x1080 display uses only the top left
> > 1024x768, and auto-configured X will end up only 1024x768 as well.
> > With this change, graphical boot and X both do 1920x1080 as expected.
> > 
> > Note that we're simply embracing and extending the early bail-out code
> > in place for the Mac Mini here. The xorg intel driver uses pci
> > subsystem device and vendor id for matching, while we're using dmi
> > lookups here. The MSI addition is courtesy of and tested by Bill
> > Nottingham.
> > 
> > One minor issue... Current Fedora rawhide, video playback using Xv
> > makes X go off into the weeds with this patch added, but that's a bug
> > elsewhere, still confident this patch DTRT.
> > 
> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> > Tested-by: Bill Nottingham <notting@redhat.com>
> 
> The 2D driver has a similar set of quirks, but since we started that
> list we've found that the VBIOS should contain a pretty reliable table
> indicating which outputs are available, including LVDS.  I think if we
> can figure out how to parse it reliably (accounting for VBIOS
> versioning and structure size changes) we shouldn't need this patch.
> If we can't get that done in time for 2.6.30 though I'm all for
> including this.

Sounds like a plan to me. Either way, would this patch still make sense
for submission to the 2.6.29.x stable series? I've already tacked it
onto the Fedora 2.6.29 kernel builds, fwiw.

-- 
Jarod Wilson
jarod@redhat.com
