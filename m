Return-Path: <linux-kernel-owner+w=401wt.eu-S1760684AbXKANHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684AbXKANHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 09:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbXKANHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 09:07:35 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36776 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753726AbXKANHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 09:07:34 -0400
Date: Thu, 1 Nov 2007 06:07:33 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Jackson <pj@sgi.com>
cc: rientjes@google.com, Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org,
       ak@suse.de
Subject: Re: [RFC] cpuset relative memory policies - second choice
In-Reply-To: <20071031233352.959c32d0.pj@sgi.com>
Message-ID: <Pine.LNX.4.64.0711010604210.27666@schroedinger.engr.sgi.com>
References: <20071031061729.18174.60384.sendpatchset@jackhammer.engr.sgi.com>
 <Pine.LNX.4.64.0710311157310.21799@schroedinger.engr.sgi.com>
 <20071031131949.b91bf383.pj@sgi.com> <Pine.LNX.4.64.0710311402300.22599@schroedinger.engr.sgi.com>
 <20071031214719.81f8293a.pj@sgi.com> <Pine.LNX.4.64.0710312221140.26444@schroedinger.engr.sgi.com>
 <20071031233352.959c32d0.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007, Paul Jackson wrote:

> > You are managing it in the task struct. No need to. libnuma can handle it.
> 
> No - as noted, not all mempolicy system calls go via libnuma.

Well then show me.

> > No current version of libcpuset is available.
> 
> Wrong.  It has not received wide publication yet, but it has been
> provided to various others under LGPL license.

The last version that I remember was for 2.4.x.

>     A search of some old SGI release software sitting on an internal
>     server just now suggests that products with names including histx,
>     gru, libmpi and pcp might be directly invoking these system calls
>     ... I didn't actually examine the source to determine whether
>     they really use these direct calls -- just got a grep hit.

A good argument to leave the API unchanged and not create magic task 
flags.

> > > With the mode bit as in my patch, there are fewer places in the user
> > > code that have to be gotten just right.  With your way, each and
> > > every mbind and *_mempolicy call has to be hacked with the new flag
> > > if one is going to use the new nodemask bit numbering.  Some of these
> > 
> > Yes and that makes sure it is thought through and done right.
> 
> Maybe for you.  Not for the rest of us error prone mere mortals.

> Forcing coders to specify the same detail in multiple places, when
> there is no way to validate their consistency, doesn't force them
> to think or do it right.  It increases the error rate due to

There are always wrappers for system calls. The flags will be set in 
these.
