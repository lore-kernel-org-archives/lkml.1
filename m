Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbXKDUMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbXKDUMi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 15:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbXKDUM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 15:12:29 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48997 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbXKDUM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 15:12:28 -0500
Subject: Re: [patch] PID namespaces
From: Dave Hansen <haveblue@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org,
       "Dinakar Guniguntala [imap]" <dino@in.ibm.com>,
       Sripathi Kodi <sripathik@in.ibm.com>
In-Reply-To: <20071104103851.GA14317@elte.hu>
References: <4729E7E4.8070208@openvz.org> <4729E936.4040400@redhat.com>
	 <4729EB3C.9050102@openvz.org> <472A6D91.1020300@redhat.com>
	 <472AD7D6.80900@openvz.org>
	 <20071102010419.23f3db5c.akpm@linux-foundation.org>
	 <1194024622.6271.108.camel@localhost>
	 <alpine.LFD.0.999.0711021038480.3342@woody.linux-foundation.org>
	 <20071103201251.GB26366@elte.hu>
	 <alpine.LFD.0.999.0711031535450.15101@woody.linux-foundation.org>
	 <20071104103851.GA14317@elte.hu>
Content-Type: text/plain
Date: Sun, 04 Nov 2007 12:12:11 -0800
Message-Id: <1194207131.6271.122.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-11-04 at 11:38 +0100, Ingo Molnar wrote:
> I.e. keep the namespace functionality but use a modulo 1.000.000 base 
> for the PIDs so that it all looks nicer to the user. Minimal visibility 
> difference but maximum compatibility. (The resulting limits are 
> reasonable: 1 million tasks per container and 4 million containers on a 
> single 32-bit box.) We could still restrict cross-namespace API use but 
> all the cases where a global PID is desirable would still all work. I 
> might be missing something obvious though.

There is definitely a great deal of desire to have containers look as
much as possible like a normally functioning system.  That includes
having an init process.  Everything today depends on that init process
having a pretty specific pid.  That's definitely one of the 0.1% of
things that isn't really shaped by the kernel, but it's a pretty
important one 0.1%.  (Linux Vserver does this pid virtualization, but
_only_ for init, btw.)

We also need to consider the needs of a checkpoint/restart system.  Most
of my interest in containers comes because of their isolation
properties.  That isolation is what lets us pick a container up and move
it more easily across systems.

But, once we've moved the container, all of that "single, global kernel"
stuff goes out the window because it wasn't just one kernel making
decisions.  Plus, those pids stop becoming just cookies that were issued
by one kernel and interpreted by one kernel.

-- Dave

