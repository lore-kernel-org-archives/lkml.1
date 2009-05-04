Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbZEDWOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbZEDWOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 18:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbZEDWOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 18:14:43 -0400
Received: from outbound-mail-31.bluehost.com ([69.89.18.151]:55637 "HELO
	outbound-mail-31.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752520AbZEDWOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 18:14:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ooE/5oDpFw9dlXQC/e6FtkweWKTdc1eJY0pKV2xKaDA/hYWU4oRgFUeR5F1k4xclC4b2GUZ3h0wasKBvt/UMJu/v3wQ1botEDOaYGfbiy/FMiHTKCRHqbCI59NFPpHa3;
Date: Mon, 4 May 2009 15:14:39 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jarod Wilson <jarod@redhat.com>, dri-devel@lists.sourceforge.net,
       xorg-devel@lists.x.org, linux-kernel@vger.kernel.org,
       notting@redhat.com, Zhenyu Wang <zhenyu.z.wang@intel.com>,
       Fu Michael <michael_fu@linux.intel.com>
Subject: Re: [PATCH] drm: ignore LVDS on intel graphics systems that lie
 about having it
Message-ID: <20090504151439.0a10ec1e@hobbes>
In-Reply-To: <20090406103917.592fee0f@hobbes>
References: <200904061011.26389.jarod@redhat.com>
	<20090406095216.4361d128@hobbes>
	<200904061329.53824.jarod@redhat.com>
	<20090406103917.592fee0f@hobbes>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009 10:39:17 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Mon, 6 Apr 2009 13:29:53 -0400
> Jarod Wilson <jarod@redhat.com> wrote:
> 
> > On Monday 06 April 2009 12:52:16 Jesse Barnes wrote:
> > > On Mon, 6 Apr 2009 10:11:25 -0400
> > > Jarod Wilson <jarod@redhat.com> wrote:
> > > 
> > > > There are a number of small form factor desktop systems with
> > > > Intel mobile graphics chips that lie and say they have an LVDS.
> > > > With kernel mode-setting, this becomes a problem, and makes
> > > > native resolution boot go haywire -- for example, my Dell
> > > > Studio Hybrid, hooked to a 1920x1080 display claims to have a
> > > > 1024x768 LVDS, and the resulting graphical boot on the
> > > > 1920x1080 display uses only the top left 1024x768, and
> > > > auto-configured X will end up only 1024x768 as well. With this
> > > > change, graphical boot and X both do 1920x1080 as expected.
> > > > 
> > > > Note that we're simply embracing and extending the early
> > > > bail-out code in place for the Mac Mini here. The xorg intel
> > > > driver uses pci subsystem device and vendor id for matching,
> > > > while we're using dmi lookups here. The MSI addition is
> > > > courtesy of and tested by Bill Nottingham.
> > > > 
> > > > One minor issue... Current Fedora rawhide, video playback using
> > > > Xv makes X go off into the weeds with this patch added, but
> > > > that's a bug elsewhere, still confident this patch DTRT.
> > > > 
> > > > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> > > > Tested-by: Bill Nottingham <notting@redhat.com>
> > > 
> > > The 2D driver has a similar set of quirks, but since we started
> > > that list we've found that the VBIOS should contain a pretty
> > > reliable table indicating which outputs are available, including
> > > LVDS.  I think if we can figure out how to parse it reliably
> > > (accounting for VBIOS versioning and structure size changes) we
> > > shouldn't need this patch. If we can't get that done in time for
> > > 2.6.30 though I'm all for including this.
> > 
> > Sounds like a plan to me. Either way, would this patch still make
> > sense for submission to the 2.6.29.x stable series? I've already
> > tacked it onto the Fedora 2.6.29 kernel builds, fwiw.
> 
> Yeah would be fine for 2.6.29 as far as I'm concerned, but there's an
> "upstream first" policy for the stable series that might get in the
> way...

Ok we've failed on this one, so we should go ahead an add the LVDS
quirk.  Can you resend this to Eric so it gets into 2.6.30-final?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
