Return-Path: <linux-kernel-owner+w=401wt.eu-S1766993AbXDSVRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766993AbXDSVRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 17:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766991AbXDSVRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 17:17:05 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:50958 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1766993AbXDSVRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 17:17:04 -0400
Subject: Re: AppArmor FAQ
From: Stephen Smalley <sds@tycho.nsa.gov>
To: David Wagner <daw-usenet@taverner.cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <f08ktq$c88$2@taverner.cs.berkeley.edu>
References: <20070416213350.GB4030@suse.de>
	 <1176822230.3366.65.camel@localhost.localdomain>
	 <462553A9.70504@novell.com>
	 <1177005419.27654.157.camel@moss-spartans.epoch.ncsc.mil>
	 <f08ktq$c88$2@taverner.cs.berkeley.edu>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 19 Apr 2007 17:17:01 -0400
Message-Id: <1177017421.27654.307.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-19 at 20:54 +0000, David Wagner wrote:
> Stephen Smalley  wrote:
> >Integrity protection requires information flow control; you can't
> >protect a high integrity process from being corrupted by a low integrity
> >process if you don't control the flow of information.  Plenty of attacks
> >take the form of a untrusted process injecting data that will ultimately
> >be used by a more trusted process with a surprising side effect.
> 
> I don't agree with this blanket statement.  In a number of cases
> of practical interest, useful integrity protection can be achieved
> without full information flow control.  Suppose you have a malicious
> ("low integrity") process A, and a target ("high integrity") process B.
> We want to prevent A from attacking B.  One way to do that is to ensure
> that A has no overt channel it can use to attack process B, by severely
> restricting A's ability to cause side effects on the rest of the world.
> This is often sufficient to contain the damage that A can do.

If you could do that, I'd call that information flow control - I wasn't
saying you had to eliminate covert channels.  As you said, we don't deal
with those even in SELinux.  The point is that AA can't even do that,
not only because it has incomplete controls but because it bases its
decisions on unreliable identifiers (paths) that doesn't let it provide
global and persistent protection of the data.

> Of course, if the intended functionality of the system requires A to
> communicate data to B, and if you don't trust B's ability to handle
> that data carefully enough, and if A is malicious, then you've got a
> serious problem.
> 
> But in a number of cases (enough cases to be useful), you can provide
> a useful level of security without needing information flow control and
> without needing global, persistent labels.

Without a reliable way of identifying the data in a system view, you
can't say anything at all about the data flows.  The labels provide you
with a way of doing that.  The paths are ambiguous, highly mutable, and
often meaningless (particularly for runtime files, temporary files, etc)
from a security pov.

Simple example:  malicious symlink attacks.

-- 
Stephen Smalley
National Security Agency

