Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbXKAFZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbXKAFZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 01:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbXKAFZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 01:25:12 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54579 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752135AbXKAFZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 01:25:11 -0400
Date: Wed, 31 Oct 2007 22:25:10 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Jackson <pj@sgi.com>
cc: rientjes@google.com, Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org,
       ak@suse.de
Subject: Re: [RFC] cpuset relative memory policies - second choice
In-Reply-To: <20071031214719.81f8293a.pj@sgi.com>
Message-ID: <Pine.LNX.4.64.0710312221140.26444@schroedinger.engr.sgi.com>
References: <20071031061729.18174.60384.sendpatchset@jackhammer.engr.sgi.com>
 <Pine.LNX.4.64.0710311157310.21799@schroedinger.engr.sgi.com>
 <20071031131949.b91bf383.pj@sgi.com> <Pine.LNX.4.64.0710311402300.22599@schroedinger.engr.sgi.com>
 <20071031214719.81f8293a.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007, Paul Jackson wrote:

> Christoph, replying to pj:
> > > Well, the mpol_nodemask_mode already is char.  So I guess you're
> > > asking if we should change 'policy' to type char as well.
> > 
> > Right.
> 
> Ok - but why?
> 
> I don't see that it matters whether policy is short or char.

It looks strange if they have different. Maybe use u8 for both?

> > s/numactl/libnuma/
> 
> So you would rather have libnuma manage this flag?
> 
> As opposed to what else managing it?  I'm still a tad confused on
> what you're suggesting on this one.

You are managing it in the task struct. No need to. libnuma can handle it.

> > But that is only done in libnuma. User code does not call this directly.
> 
> I disagree.
> 
> There are several mempolicy interfaces in use, including at least:
>  1) libnuma, which in turn is based on (5), below
>  2) the numactl command line utility (based on libnuma)
>  3) libcpuset (which has its own modest mempolicy interface)

These are no problem 1/2 are libnuma. No current version of libcpuset
is available.

>  4) the glibc mbind/set_mempolicy/get_mempolicy wrappers, in C code
>  5) roll your own mbind/*_mempolicy system call wrappers, in C code

Those exist? Never seen that.

> With the mode bit as in my patch, there are fewer places in the user
> code that have to be gotten just right.  With your way, each and
> every mbind and *_mempolicy call has to be hacked with the new flag
> if one is going to use the new nodemask bit numbering.  Some of these

Yes and that makes sure it is thought through and done right.

> Perhaps that's the way to go:
>     mbind2, get_mempolicy2, and set_mempolicy2.

That would be okay from the backwards compat standpoint.
