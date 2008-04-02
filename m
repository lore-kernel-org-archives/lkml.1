Return-Path: <linux-kernel-owner+w=401wt.eu-S1761570AbYDBVgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761570AbYDBVgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759779AbYDBVg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:36:26 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36554 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753811AbYDBVg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:36:26 -0400
Date: Wed, 2 Apr 2008 14:33:51 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Hugh Dickins <hugh@veritas.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Nick Piggin <npiggin@suse.de>
Subject: Re: EMM: Fixup return value handling of emm_notify()
In-Reply-To: <20080402212515.GS19189@duo.random>
Message-ID: <Pine.LNX.4.64.0804021427210.30516@schroedinger.engr.sgi.com>
References: <20080401205531.986291575@sgi.com> <20080401205635.793766935@sgi.com>
 <20080402064952.GF19189@duo.random> <Pine.LNX.4.64.0804021048460.27214@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0804021202450.28436@schroedinger.engr.sgi.com>
 <20080402212515.GS19189@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, Andrea Arcangeli wrote:

> but anyway it's silly to be hardwired to such an interface that worst
> of all requires switch statements instead of proper pointer to
> functions and a fixed set of parameters and retval semantics for all
> methods.

The EMM API with a single callback is the simplest approach at this point. 
A common callback for all operations allows the driver to implement common 
entry and exit code as seen in XPMem.

I guess we can complicate this more by switching to a different API or 
adding additional emm_xxx() callback if need be but I really want to have 
a strong case for why this would be needed. There is the danger of 
adding frills with special callbacks in this and that situation that could 
make the notifier complicated and specific to a certain usage scenario. 

Having this generic simple interface will hopefully avoid such things.


