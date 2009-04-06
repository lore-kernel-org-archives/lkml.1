Return-Path: <linux-kernel-owner+w=401wt.eu-S1753099AbZDFRjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbZDFRjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 13:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbZDFRj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 13:39:27 -0400
Received: from outbound-mail-107.bluehost.com ([69.89.22.7]:34312 "HELO
	outbound-mail-107.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750804AbZDFRj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 13:39:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=MiqURSRjd4Q0zUZGvDMzzf0oql2R021Z+pBT7x2f6yzTgVxNl7Aoh1kUFUwOSevA1JQJckXbqC2VtRug5fPpVtk3tL/7AK9mynr933LpknBZ59KTJPKMof/9Yg4TG+CR;
Date: Mon, 6 Apr 2009 10:39:17 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jarod Wilson <jarod@redhat.com>
Cc: dri-devel@lists.sourceforge.net, xorg-devel@lists.x.org,
       linux-kernel@vger.kernel.org, notting@redhat.com,
       Zhenyu Wang <zhenyu.z.wang@intel.com>,
       Fu Michael <michael_fu@linux.intel.com>
Subject: Re: [PATCH] drm: ignore LVDS on intel graphics systems that lie
 about having it
Message-ID: <20090406103917.592fee0f@hobbes>
In-Reply-To: <200904061329.53824.jarod@redhat.com>
References: <200904061011.26389.jarod@redhat.com>
	<20090406095216.4361d128@hobbes>
	<200904061329.53824.jarod@redhat.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009 13:29:53 -0400
Jarod Wilson <jarod@redhat.com> wrote:

> On Monday 06 April 2009 12:52:16 Jesse Barnes wrote:
> > On Mon, 6 Apr 2009 10:11:25 -0400
> > Jarod Wilson <jarod@redhat.com> wrote:
> > 
> > > There are a number of small form factor desktop systems with Intel
> > > mobile graphics chips that lie and say they have an LVDS. With
> > > kernel mode-setting, this becomes a problem, and makes native
> > > resolution boot go haywire -- for example, my Dell Studio Hybrid,
> > > hooked to a 1920x1080 display claims to have a 1024x768 LVDS, and
> > > the resulting graphical boot on the 1920x1080 display uses only
> > > the top left 1024x768, and auto-configured X will end up only
> > > 1024x768 as well. With this change, graphical boot and X both do
> > > 1920x1080 as expected.
> > > 
> > > Note that we're simply embracing and extending the early bail-out
> > > code in place for the Mac Mini here. The xorg intel driver uses
> > > pci subsystem device and vendor id for matching, while we're
> > > using dmi lookups here. The MSI addition is courtesy of and
> > > tested by Bill Nottingham.
> > > 
> > > One minor issue... Current Fedora rawhide, video playback using Xv
> > > makes X go off into the weeds with this patch added, but that's a
> > > bug elsewhere, still confident this patch DTRT.
> > > 
> > > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> > > Tested-by: Bill Nottingham <notting@redhat.com>
> > 
> > The 2D driver has a similar set of quirks, but since we started that
> > list we've found that the VBIOS should contain a pretty reliable
> > table indicating which outputs are available, including LVDS.  I
> > think if we can figure out how to parse it reliably (accounting for
> > VBIOS versioning and structure size changes) we shouldn't need this
> > patch. If we can't get that done in time for 2.6.30 though I'm all
> > for including this.
> 
> Sounds like a plan to me. Either way, would this patch still make
> sense for submission to the 2.6.29.x stable series? I've already
> tacked it onto the Fedora 2.6.29 kernel builds, fwiw.

Yeah would be fine for 2.6.29 as far as I'm concerned, but there's an
"upstream first" policy for the stable series that might get in the
way...

-- 
Jesse Barnes, Intel Open Source Technology Center
