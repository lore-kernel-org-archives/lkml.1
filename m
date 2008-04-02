Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbYDBSSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbYDBSSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbYDBSSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:18:00 -0400
Received: from relay1.sgi.com ([192.48.171.29]:36336 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751886AbYDBSR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:17:59 -0400
Date: Wed, 2 Apr 2008 11:15:26 -0700 (PDT)
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
       daniel.blueman@quadrics.com
Subject: Re: [patch 5/9] Convert anon_vma lock to rw_sem and refcount
In-Reply-To: <20080402175058.GR19189@duo.random>
Message-ID: <Pine.LNX.4.64.0804021107520.27337@schroedinger.engr.sgi.com>
References: <20080401205531.986291575@sgi.com> <20080401205636.777127252@sgi.com>
 <20080402175058.GR19189@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, Andrea Arcangeli wrote:

> On Tue, Apr 01, 2008 at 01:55:36PM -0700, Christoph Lameter wrote:
> >   This results in f.e. the Aim9 brk performance test to got down by 10-15%.
> 
> I guess it's more likely because of overscheduling for small crtitical
> sections, did you counted the total number of context switches? I
> guess there will be a lot more with your patch applied. That
> regression is a showstopper and it is the reason why I've suggested
> before to add a CONFIG_XPMEM or CONFIG_MMU_NOTIFIER_SLEEP config
> option to make the VM locks sleep capable only when XPMEM=y
> (PREEMPT_RT will enable it too). Thanks for doing the benchmark work!

There are more context switches if locks are contended. 

But that has actually also some good aspects because we avoid busy loops 
and can potentially continue work in another process.

