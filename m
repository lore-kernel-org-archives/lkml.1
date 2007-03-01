Return-Path: <linux-kernel-owner+w=401wt.eu-S932801AbXCAABZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801AbXCAABZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 19:01:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932800AbXCAABZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 19:01:25 -0500
Received: from firewall.rowland.harvard.edu ([140.247.233.35]:46185 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S932801AbXCAABY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 19:01:24 -0500
Date: Wed, 28 Feb 2007 19:01:17 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, <eranian@hpl.hp.com>,
       <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
       <ak@suse.de>, <tony.luck@intel.com>, William Cohen <wcohen@redhat.com>
Subject: Re: debug registers and fork
In-Reply-To: <20070228212510.1E213180067@magilla.sf.frob.com>
Message-ID: <Pine.LNX.4.44L0.0702281847330.24215-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007, Roland McGrath wrote:

> It is true that debug registers are inherited by fork and clone.
> I am 99% sure that this was never specifically intended, but it
> has been this way for a long time (since 2.4 at least).  It's an
> implicit consequence of the do_fork implementation style, which
> does a blind copy of the whole task_struct and then explicitly
> reinitializes some individual fields.  I suppose this has some
> benefit or other, but it is very prone to new pieces of state
> getting implicitly copied without the person adding that new state
> ever consciously deciding what its inheritance semantics should be.
> 
> Alan Stern is working on a revamp of the x86 debug register
> support.  This is a fine opportunity to clean this area up and
> decide positively what the semantics ought to be.

Absolutely.  Right now I just have a placeholder function with a note
about checking for CLONE_PTRACE.  The cleanest solution, far and away,
would be to have the child process inherit no breakpoints and no debug
register values.

Alan Stern

