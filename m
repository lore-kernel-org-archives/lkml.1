Return-Path: <linux-kernel-owner+w=401wt.eu-S1758628AbYDYOeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628AbYDYOeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 10:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYDYOdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 10:33:55 -0400
Received: from twin.jikos.cz ([213.151.79.26]:34993 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbYDYOdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 10:33:54 -0400
Date: Fri, 25 Apr 2008 16:33:48 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Gerhard Mack <gmack@innerfire.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.25] compat VDSO option not disabling
In-Reply-To: <alpine.DEB.1.10.0804241244360.28216@mtl.rackplans.net>
Message-ID: <Pine.LNX.4.64.0804251632490.19002@twin.jikos.cz>
References: <alpine.DEB.1.10.0804241244360.28216@mtl.rackplans.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2008, Gerhard Mack wrote:

> On my laptop I disabled the compat vdso option but it is till being 
> mapped.. Any ideas?

The changelog of the commit below explains that.

commit 1dbf527c51c6c20c19869c8125cb5b87c3d09506
Author: Jeremy Fitzhardinge <jeremy@goop.org>
Date:   Wed May 2 19:27:12 2007 +0200

    [PATCH] i386: Make COMPAT_VDSO runtime selectable.

    Now that relocation of the VDSO for COMPAT_VDSO users is done at
    runtime rather than compile time, it is possible to enable/disable
    compat mode at runtime.

    This patch allows you to enable COMPAT_VDSO mode with "vdso=2" on the
    kernel command line, or via sysctl.  (Switching on a running system
    shouldn't be done lightly; any process which was relying on the compat
    VDSO will be upset if it goes away.)

    The COMPAT_VDSO config option still exists, but if enabled it just
    makes vdso_enabled default to VDSO_COMPAT.

-- 
Jiri Kosina
SUSE Labs

