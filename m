Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbXDREyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbXDREyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 00:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbXDREyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 00:54:08 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55130 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753684AbXDREyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 00:54:07 -0400
Date: Tue, 17 Apr 2007 21:54:04 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Larry Woodman <lwoodman@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysctl_panic_on_oom broken
In-Reply-To: <1176855875.3959.7.camel@dhcp83-56.boston.redhat.com>
Message-ID: <Pine.LNX.4.64.0704172152450.2877@schroedinger.engr.sgi.com>
References: <462515CC.1080107@redhat.com>  <Pine.LNX.4.64.0704171438390.8082@schroedinger.engr.sgi.com>
 <1176855875.3959.7.camel@dhcp83-56.boston.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2007, Larry Woodman wrote:

> On Tue, 2007-04-17 at 14:39 -0700, Christoph Lameter wrote:
> 
> > 
> > It recreates the old problem that we OOM while we still have memory 
> > in other parts of the system.
> 
> How, by the time we get here we have already decided we are going to
> OOMkill or panic.  This change just obeys sysctl_panic_on_oom before
> killing current.

If you panic then there is no reason to kill current. Lets say you
have a 10 node system and the application attempt to allocate from node 8 
which has no reclaimable memory then the application has a problem not the 
system as a whole.
