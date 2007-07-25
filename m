Return-Path: <linux-kernel-owner+w=401wt.eu-S1765090AbXGYIEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765090AbXGYIEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 04:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760932AbXGYIDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 04:03:54 -0400
Received: from styx.suse.cz ([82.119.242.94]:51268 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760755AbXGYIDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 04:03:49 -0400
Date: Wed, 25 Jul 2007 10:03:55 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Lalancette <clalance@redhat.com>, linux-kernel@vger.kernel.org,
       dmitry.torokhov@gmail.com, linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH]: Add command-line option to i8042 to completely disable it
Message-ID: <20070725080355.GA14726@suse.cz>
References: <46A4DFD2.2010501@redhat.com> <20070725000504.f8ce49c1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070725000504.f8ce49c1.akpm@linux-foundation.org>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 12:05:04AM -0700, Andrew Morton wrote:
> On Mon, 23 Jul 2007 13:05:22 -0400 Chris Lalancette <clalance@redhat.com> wrote:
> 
> > (I tried to send this patch to linux-input@, but it seems to be currently having
> > some problems, so I'm going directly to LKML).
> > 
> > Certain (broken) pieces of South Bridge hardware will respond to
> > i8042_read_status() on boot with 0x0, despite there not being a real i8042
> > controller hooked up in the south bridge.  This can cause the detection for the
> > i8042 to return a "phantom" device, which hangs up later initialization.  Note
> > that using "i8042.nokbd" and/or "i8042.noaux" do not help with this, since this
> > shows up during i8042_controller_check() (before either of those options are
> > checked).  This patch adds a command-line option "i8042.disable", which just
> > completely disables any checking for the i8042 controller.
> 
> That's an unfortunate fix.  Is there really no way in which we
> can auto-detect such a situation without requiring a manual
> setting?

The fact that the current detection hangs suggests that the scenario is
possible to detect.

-- 
Vojtech Pavlik
Director SuSE Labs
