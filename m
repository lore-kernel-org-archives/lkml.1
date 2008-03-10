Return-Path: <linux-kernel-owner+w=401wt.eu-S1756401AbYCJW0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401AbYCJW0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbYCJWZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:25:57 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:45718 "EHLO
	outbound2-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751167AbYCJWZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:25:56 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0JXJCVE-03-DB3-01
Date: Mon, 10 Mar 2008 16:24:07 -0600
From: Jordan Crouse <jordan.crouse@amd.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, adaplas@gmail.com,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       info-linux@geode.amd.com, rjw@sisk.pl, samuel.thibault@ens-lyon.org
Subject: Re: PM/FB/gxfb: add config option that allows disabling of VT
	switch during suspend
Message-ID: <20080310222407.GD589@cosmic.amd.com>
References: <20080308204927.73afa56c@ephemeral> <20080310141939.ce1169c0.akpm@linux-foundation.org> <20080310174424.29621e62@ephemeral> <20080310145118.adb0cf1e.akpm@linux-foundation.org> <20080310181446.2fb85eea@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080310181446.2fb85eea@ephemeral>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 10 Mar 2008 22:23:09.0404 (UTC) FILETIME=[51FEA9C0:01C882FD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/08 18:14 -0400, Andres Salomon wrote:
> On Mon, 10 Mar 2008 14:51:18 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Mon, 10 Mar 2008 17:44:24 -0400
> > Andres Salomon <dilinger@queued.net> wrote:
> > 
> > > On Mon, 10 Mar 2008 14:19:39 -0700
> > > Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > 
> > > > It would be far preferable to do this via a kernel boot parameter rather
> > > > than via a kernel rebuild.
> > > > 
> > > 
> > > Well, it shouldn't be supported at _all_ unless the framebuffer driver
> > > supports it; you're asking for it to be converted to something like the
> > > following?
> > > 
> > > 
> > > 
> > > #ifdef CONFIG_FBDEV_SUPPORTS_NOSWITCH
> > > static int no_vt_switch;
> > > #endif
> > > 
> > > int pm_prepare_console(void)
> > > {
> > > #ifdef CONFIG_FBDEV_SUPPORTS_NOSWITCH
> > > 	if (no_vt_switch)
> > > 		return 0;
> > > #endif
> > > 	...
> > > }
> > > 
> > > #ifdef CONFIG_FBDEV_SUPPORTS_NOSWITCH
> > > module_param(no_vt_switch, int, 0);
> > > MODULE_PARM_DESC(no_vt_switch, "...");
> > > #endif
> > > 
> > > 
> > > If so, that means extra #ifdef's sprinkled throughout the code.  Note
> > > that most framebuffer drivers won't be supporting this, and those that
> > > do will almost certainly always want vt switching turned off..
> > > 
> > 
> > I don't think you need any ifdefs or config options at all, do you?  Just
> > add a new module parameter to this driver and some little interface into
> > the PM core which allows the driver to set no_vt_switch?
> > 
> 
> That's a possibility, but doesn't adding hooks into PM core for two
> drivers (lxfb and gxfb) seems like overkill?  I also don't really see
> anyone needing to switch back and forth between VT_SWITCH and
> NO_VT_SWITCH other than to work around possible bugs in the register
> save/restore code..

I like Andrew's idea.  I wager This won't be Geode specific for long.
Either other drivers will get the hint and add real save/restore code
or the GPU subystem code being worked on by the X folks will come along
and make the VT switch obsolete for everybody.  Either way, I see hooks
in the PM core as generic love that everybody can benefit from.

Jordan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.

