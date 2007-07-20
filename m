Return-Path: <linux-kernel-owner+w=401wt.eu-S1752311AbXGTV1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311AbXGTV1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765760AbXGTV0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:26:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39900 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765471AbXGTV0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:26:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [linux-pm] Re: Hibernation considerations
Date: Fri, 20 Jul 2007 23:34:40 +0200
User-Agent: KMail/1.9.5
Cc: Milton Miller <miltonm@bga.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, David Lang <david@lang.hm>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
References: <Pine.LNX.4.64.0707171319140.2467@asgard.lang.hm> <40fa2626aff7b6b590ad6aa4737fc873@bga.com> <1184942918.13737.23.camel@caritas-dev.intel.com>
In-Reply-To: <1184942918.13737.23.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707202334.41665.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 20 July 2007 16:48, Huang, Ying wrote:
> On Fri, 2007-07-20 at 09:01 -0500, Milton Miller wrote:
> > Simplifying kjump: the proposal for v3.
> > 
> > The current code is trying to use crash dump area as a safe, reserved 
> > area to run the second kernel.   However, that means that the kernel 
> > has to be linked specially to run in the reserved area.   I think we 
> > need to finish separating kexec_jump from the other code paths.
> > 
> > (1) add a new command line argument that specifies the kexec_jump 
> > target area (or just size?)
> > 
> > (2) add a kjump flag to the flags parameter, used by kexec_load.   When 
> > loading a jump kernel, it is loaded like a normal kernel, however, 
> > additional control pages are allocated to (a) save this kenrel's use of 
> > the kexec_jump target area (b) save the backed up region that is used 
> > by all kernels like crash dump, and (c) space for invoking 
> > relocate_new_kernel that will get its args from the execution entry 
> > point and will restore the kernel then call resume and suspend.
> 
> Backuping target memory before kexec and restoring it after kexec is
> planed feature for kexec jump. But I will work on image writing/reading
> first.

Have you thought about using any existing code, when you're at it?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
