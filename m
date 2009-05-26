Return-Path: <linux-kernel-owner+w=401wt.eu-S1753010AbZEZCbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbZEZCbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 22:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZEZCbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 22:31:25 -0400
Received: from THUNK.ORG ([69.25.196.29]:46917 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbZEZCbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 22:31:24 -0400
Date: Mon, 25 May 2009 22:31:05 -0400
From: Theodore Tso <tytso@mit.edu>
To: Richard M Stallman <rms@gnu.org>
Cc: Pavel Machek <pavel@ucw.cz>, joseph.cihula@intel.com, jmorris@namei.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       hpa@zytor.com, andi@firstfloor.org, chrisw@sous-sol.org,
       jbeulich@novell.com, peterm@redhat.com, gang.wei@intel.com,
       shane.wang@intel.com, gnu@toad.com
Subject: Re: [RFC v3][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel
	support
Message-ID: <20090526023105.GB27648@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Richard M Stallman <rms@gnu.org>, Pavel Machek <pavel@ucw.cz>,
	joseph.cihula@intel.com, jmorris@namei.org,
	linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
	hpa@zytor.com, andi@firstfloor.org, chrisw@sous-sol.org,
	jbeulich@novell.com, peterm@redhat.com, gang.wei@intel.com,
	shane.wang@intel.com, gnu@toad.com
References: <4A03B9C3.9090607@intel.com> <20090512210154.GC23773@mit.edu> <alpine.LRH.2.00.0905151006020.5527@tundra.namei.org> <4F65016F6CB04E49BFFA15D4F7B798D99B4752F3@orsmsx506.amr.corp.intel.com> <20090524194231.GB1337@ucw.cz> <E1M8kJQ-0000W3-TE@fencepost.gnu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1M8kJQ-0000W3-TE@fencepost.gnu.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 08:14:36PM -0400, Richard M Stallman wrote:
>     Linus says he hates drm but does not want to stop it through legal
>     means, because its impossible.
> 
> It is quite possible to block use of DRM in Linux.  All they need to
> do is move to GPLv3.  Eben Moglen worked out for them how they could
> do this if they want to.

Actually, moving Linux to GPLv3 would do absolutely nothing to stop
DRM as implemented by the LaGrande/TXT technology.  That's because
what is actually running inside the trusted execution environment
doesn't have to be GPL'ed code at all.  It doesn't even really need to
be an OS, since it relies on Linux to effectively be a sophisticated
bootloader and networking stack and windowing manager for it.

This is one of the reasons why I've always personally thought it was a
very bad idea to try to stop DRM via copyright licenses such as the
GPLv3; you might be able to prevent one which requires a "trusted
kernel", via the GPLv3's "anti-TIVO clause".  However, the
LaGrande/TXT doesn't require a trusted kernel.  You can modify the
kernel all you want.  However, if the kernel tries tampering with the
trusted image which TXT provides, it will be detected and the trusted
boot operation will fail --- but the code which does the digital
signature check and the code running in the tboot environment isn't
GPL'ed code at all, and part of the enforcement is done in hardware.

Consider the situation where the DRM'ed code was running as part of
Windows Vista, and so a Linux user downloaded code which ran the
DRM'ed application under Windows Vista under KVM in an virtual
environment.  It's obvious that whether Linux is licensed under GPLv2
or GPLv3 would make no difference in prohibited the DRM'ed code to be
run in VM, right?  TXT is basically this, except that (a) the hardware
provides strong protection against tampering once the trusted
environment is established, and (b) there are well defined interfaces
for thet trusted enviroment use the filesystem, device drivers, and
networking stack of the host OS to do its I/O (with everything stored
in the filesystem, or fetched over the network, protected via either
encryption or digital signatures, or both).

GPLv3 simply won't help address the DRM issue in this situation ---
just as the GPLv3 won't prevent the next Bernie Madoff from using
GPL'ed software to run a Ponzi scheme.  Sometimes, you can't use
copyright licenses to prevent people from doing evil things with the
software that we write and maintain.  That doesn't excuse the bad use
cases; just that copyright licenses isn't the right tool to use to
prevent these situations from happening.

							- Ted
