Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbYCJVwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbYCJVwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 17:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbYCJVwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 17:52:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751014AbYCJVw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 17:52:29 -0400
Date: Mon, 10 Mar 2008 14:51:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andres Salomon <dilinger@queued.net>
Cc: adaplas@gmail.com, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, info-linux@geode.amd.com,
       jordan.crouse@amd.com, rjw@sisk.pl, samuel.thibault@ens-lyon.org
Subject: Re: [PATCH 6/6] PM/FB/gxfb: add config option that allows disabling
 of VT switch during suspend
Message-Id: <20080310145118.adb0cf1e.akpm@linux-foundation.org>
In-Reply-To: <20080310174424.29621e62@ephemeral>
References: <20080308204927.73afa56c@ephemeral>
	<20080310141939.ce1169c0.akpm@linux-foundation.org>
	<20080310174424.29621e62@ephemeral>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008 17:44:24 -0400
Andres Salomon <dilinger@queued.net> wrote:

> On Mon, 10 Mar 2008 14:19:39 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > It would be far preferable to do this via a kernel boot parameter rather
> > than via a kernel rebuild.
> > 
> 
> Well, it shouldn't be supported at _all_ unless the framebuffer driver
> supports it; you're asking for it to be converted to something like the
> following?
> 
> 
> 
> #ifdef CONFIG_FBDEV_SUPPORTS_NOSWITCH
> static int no_vt_switch;
> #endif
> 
> int pm_prepare_console(void)
> {
> #ifdef CONFIG_FBDEV_SUPPORTS_NOSWITCH
> 	if (no_vt_switch)
> 		return 0;
> #endif
> 	...
> }
> 
> #ifdef CONFIG_FBDEV_SUPPORTS_NOSWITCH
> module_param(no_vt_switch, int, 0);
> MODULE_PARM_DESC(no_vt_switch, "...");
> #endif
> 
> 
> If so, that means extra #ifdef's sprinkled throughout the code.  Note
> that most framebuffer drivers won't be supporting this, and those that
> do will almost certainly always want vt switching turned off..
> 

I don't think you need any ifdefs or config options at all, do you?  Just
add a new module parameter to this driver and some little interface into
the PM core which allows the driver to set no_vt_switch?

