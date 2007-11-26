Return-Path: <linux-kernel-owner+w=401wt.eu-S1756971AbXKZWSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbXKZWSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 17:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755774AbXKZWSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 17:18:33 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:20825 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812AbXKZWSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 17:18:31 -0500
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
X-Message-Flag: Warning: May contain useful information
References: <20071122343.446909000@suse.de> <adatznarrzc.fsf@cisco.com>
	<200711261228.15155.rusty@rustcorp.com.au>
	<20071126102533.1c774870@freepuppy.rosehill.pdx.hemminger.net>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 26 Nov 2007 14:18:25 -0800
In-Reply-To: <20071126102533.1c774870@freepuppy.rosehill.pdx.hemminger.net> (Stephen Hemminger's message of "Mon, 26 Nov 2007 10:25:33 -0800")
Message-ID: <adave7or6q6.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Nov 2007 22:18:25.0689 (UTC) FILETIME=[43837090:01C8307A]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Agreed. On first glance, I was intrigued but:
 > 
 > 1) Why is everyone so concerned that export symbol space is large?
 > 	- does it cost cpu or running memory?
 > 	- does it cause bugs?
 > 	- or are you just worried about "evil modules"?
 > 
 > 2) These aren't real namespaces
 > 	- all global names still have to be unique
 > 	- still have to handle the "non-modular build" namespace conflicts
 > 	- there isn't a big problem with conflicting symbols today.

Perhaps changing the name from "namespace" to "interface" would help?
Then a module could have something like

MODULE_USE_INTERFACE(foo);

and I think that makes it clearer what the advantage of this is: it
marks symbols as being part of a certain interface, requires modules
that use that interface to declare that use explicitly, and allows
reviewers to say "Hey why is this code using the scsi interface when
it's a webcam driver?"

 - R.
