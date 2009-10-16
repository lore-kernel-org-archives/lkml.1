Return-Path: <linux-kernel-owner+w=401wt.eu-S1752887AbZJPT6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbZJPT6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 15:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbZJPT6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 15:58:05 -0400
Received: from waste.org ([173.11.57.241]:37348 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbZJPT6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 15:58:04 -0400
Subject: Re: Keeping network device renaming working in the presence of
 netconsole?
From: Matt Mackall <mpm@selenic.com>
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <87zl7rp1jy.fsf@spindle.srvr.nix>
References: <87zl7rp1jy.fsf@spindle.srvr.nix>
Content-Type: text/plain
Date: Fri, 16 Oct 2009 14:57:58 -0500
Message-Id: <1255723078.14249.16.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 20:43 +0100, Nix wrote:
> So I'm testing suspend/resume and getting a lot of wildly variable
> panics on resume. I'd like to report them, so I need to capture them
> somehow.
> 
> Netconsole looks like just the thing: it even says it's nonintrusive.
> 
> Unfortunately it intrudes in one very unfortunate way: if netconsole is
> jabbering out of some network interface, that interface is up, so you
> can't rename it: and because (to catch early panics) netconsole has to
> start before userspace kicks up, this means that there is *no*
> opportunity to rename network interfaces that netconsole is operating
> over.
> 
> This breaks userspace more than slightly if you rely on udev's
> persistent net generator rules to keep network interface names constant,
> or if you rename the lot to something more memorable than ethN. Any
> userspace setup of that interface, assignment of additional addresses,
> routing, MTU setting et al is all toast: and you can't stop using
> interface renaming unless you like your interfaces to change identities
> intermittently (but we've had that flamewar).

A device definitely does have to be up for netconsole to work.

But as far as I know, there's no good reason you can't rename an
interface that's up.

But back to your original problem: netconsole is actually probably a
poor match for debugging suspend/resume as getting from an off state to
a working state in the network driver takes a non-trivial amount of
code.

A useful technique here is capturing kernel message buffers in RAM
across resets, something that can be done on most systems (provided you
can disable memory test). Alternately, you might look at firewire
techniques.

-- 
http://selenic.com : development and support for Mercurial and Linux


