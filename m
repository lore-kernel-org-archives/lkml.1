Return-Path: <linux-kernel-owner+w=401wt.eu-S1762213AbYCGWrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762213AbYCGWrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 17:47:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbYCGWq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 17:46:57 -0500
Received: from relay2.sgi.com ([192.48.171.30]:48878 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750740AbYCGWq4 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 17:46:56 -0500
Date: Sat, 8 Mar 2008 09:46:45 +1100
From: David Chinner <dgc@sgi.com>
To: Chris Knadle <Chris.Knadle@coredump.us>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: assfail during unmount xfs 2.6.24.3 [from 2.6.24.y git]
Message-ID: <20080307224645.GW155259@sgi.com>
References: <200803062329.10486.Chris.Knadle@coredump.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803062329.10486.Chris.Knadle@coredump.us>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 11:29:07PM -0500, Chris Knadle wrote:
> During the final unmount before reboot there was an assertion failure from XFS 
> leading to the debug output below; I've included what was available on the 
> screendump, which I handwrote + transcribed.  [I also have screenshots from a 
> 2.1 MP camera -- they're slightly ugly but usable.]  CONFIG_KEXEC was not 
> compiled in, so I was uanble to get a crashdump via SysRq.  I'm sending this 
> along in case someone working on the XFS fs can find + fix a bug.  I'm not 
> sending the kernel config in this first post just as not to spam everybody 
> with it if it's not needed -- if desired just ask and I'll send it.
> Source used: 2.6.24.y from git -- 2.6.24.3.
> 
> This is on my Desktop box, x86 system -- single P4 CPU @ 2.6 GHz, IDE disk 
> attached to an onboard HighPoint HPT370 controller, and running Debian Sid.
> 
> When replying please CC me, as I am not currently subscribed to the list.
......
> Assertion failed: atomic_read(&mp->m_active_trans) == 0, file: 
> fs/xfs/xfs_vfsops.c, line: 708

Known problem. Race in the VFS w.r.t. read-only remounts:

http://marc.info/?l=linux-kernel&m=120106649923499&w=2

The fix for the problem lies outside XFS:

http://marc.info/?l=linux-kernel&m=120109304227035&w=2

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
