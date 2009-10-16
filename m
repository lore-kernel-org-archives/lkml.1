Return-Path: <linux-kernel-owner+w=401wt.eu-S1754462AbZJPTnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbZJPTnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 15:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbZJPTnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 15:43:39 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:53170 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbZJPTnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 15:43:39 -0400
To: Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org
Subject: Keeping network device renaming working in the presence of netconsole?
From: Nix <nix@esperi.org.uk>
Emacs: Lovecraft was an optimist.
Date: Fri, 16 Oct 2009 20:43:29 +0100
Message-ID: <87zl7rp1jy.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-URT-Metrics: spindle 1060; Body=2 Fuz1=2 Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I'm testing suspend/resume and getting a lot of wildly variable
panics on resume. I'd like to report them, so I need to capture them
somehow.

Netconsole looks like just the thing: it even says it's nonintrusive.

Unfortunately it intrudes in one very unfortunate way: if netconsole is
jabbering out of some network interface, that interface is up, so you
can't rename it: and because (to catch early panics) netconsole has to
start before userspace kicks up, this means that there is *no*
opportunity to rename network interfaces that netconsole is operating
over.

This breaks userspace more than slightly if you rely on udev's
persistent net generator rules to keep network interface names constant,
or if you rename the lot to something more memorable than ethN. Any
userspace setup of that interface, assignment of additional addresses,
routing, MTU setting et al is all toast: and you can't stop using
interface renaming unless you like your interfaces to change identities
intermittently (but we've had that flamewar).

Is there a way to rename interfaces netconsole is working over? Why
can't you rename interfaces that are in use anyway?  Yes, there's the
name_hlist, but that's protected by the dev_base_lock anyway.
