Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbZFCTGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbZFCTGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 15:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbZFCTFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 15:05:54 -0400
Received: from THUNK.ORG ([69.25.196.29]:50857 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626AbZFCTFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 15:05:54 -0400
Date: Wed, 3 Jun 2009 15:05:21 -0400
From: Theodore Tso <tytso@mit.edu>
To: George Dunlap <george.dunlap@eu.citrix.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       "jeremy@goop.org" <jeremy@goop.org>, "avi@redhat.com" <avi@redhat.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       "xen-users@lists.xensource.com" <xen-users@lists.xensource.com>,
       ksrinivasan <ksrinivasan@novell.com>,
       "EAnderson@novell.com" <EAnderson@novell.com>,
       "wimcoekaerts@wimmekes.net" <wimcoekaerts@wimmekes.net>,
       Stephen Spector <stephen.spector@citrix.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "npiggin@suse.de" <npiggin@suse.de>
Subject: Re: Merge Xen (the hypervisor) into Linux
Message-ID: <20090603190521.GJ31943@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	George Dunlap <george.dunlap@eu.citrix.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Dan Magenheimer <dan.magenheimer@oracle.com>,
	Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
	"jeremy@goop.org" <jeremy@goop.org>,
	"avi@redhat.com" <avi@redhat.com>,
	"xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Keir Fraser <Keir.Fraser@eu.citrix.com>,
	"torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
	Ian Pratt <Ian.Pratt@eu.citrix.com>,
	"xen-users@lists.xensource.com" <xen-users@lists.xensource.com>,
	ksrinivasan <ksrinivasan@novell.com>,
	"EAnderson@novell.com" <EAnderson@novell.com>,
	"wimcoekaerts@wimmekes.net" <wimcoekaerts@wimmekes.net>,
	Stephen Spector <stephen.spector@citrix.com>,
	"jens.axboe@oracle.com" <jens.axboe@oracle.com>,
	"npiggin@suse.de" <npiggin@suse.de>
References: <3ab07e3b-a601-48d5-b350-29cbaf111892@default> <alpine.DEB.2.00.0906030108500.14994@gandalf.stny.rr.com> <4A2666A7.4060603@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2666A7.4060603@eu.citrix.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 01:03:51PM +0100, George Dunlap wrote:
> It is a very interesting idea, but it would still be basically a  
> completely new project.  If someone started such a project, they could  
> probably cannibalize a lot of Xen's existing code (a funny boomerang,  
> since Xen cannibalized Linux's code when it started), but it would still  
> require a lot of work and re-writing, and the result would be a lot  
> different than Xen is now.  It would be years before it was ready to be  
> used in a production system.  

You might be surprised; if we started with a working dom0/xen pair,
and there were people working on it to clean up dom0/xen interface,
treating it as an internal Linux interface with an eye towards
minimizing contamination of core kernel code, the Linux model of
development can go pretty fast.  Compare and contrast it with the
***years*** of calendar time and decades of wasted man-years of
engineering effort needed to port and backport and maintain dom0
support with Linux.  Given that experience, I could easily see how
some might assume that it would take years to significantly improve
things, but I suspect if xen were merged into mainline with the
assumption that it could be arbitrarily changed to make things sane,
with the primary interface that needed backwards compatibility care
being the xen/domU interface, I expect things would go pretty fast.

What would be lost is dom0 support for other OS's, but really, is that
such a major loss?  Linux has far better device driver support than
Solaris or FreeBSD, so there is really that much gain in using some
other OS for dom0?

						- Ted
