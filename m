Return-Path: <linux-kernel-owner+w=401wt.eu-S1758243AbYDBWoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243AbYDBWoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 18:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbYDBWoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 18:44:09 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39591 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755458AbYDBWoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 18:44:08 -0400
Date: Wed, 2 Apr 2008 15:41:34 -0700 (PDT)
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
Subject: Re: EMM: Require single threadedness for registration.
In-Reply-To: <20080402221716.GY19189@duo.random>
Message-ID: <Pine.LNX.4.64.0804021536020.32132@schroedinger.engr.sgi.com>
References: <20080401205531.986291575@sgi.com> <20080401205635.793766935@sgi.com>
 <20080402064952.GF19189@duo.random> <Pine.LNX.4.64.0804021048460.27214@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0804021402190.30337@schroedinger.engr.sgi.com>
 <20080402220148.GV19189@duo.random> <Pine.LNX.4.64.0804021503320.31247@schroedinger.engr.sgi.com>
 <20080402221716.GY19189@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008, Andrea Arcangeli wrote:

> Why can't it fire on the mm_struct where GRU just registered? That
> mm_struct existed way before GRU registered, and VM is free to unmap
> it w/o mmap_sem if there was any memory pressure.

Right. Hmmm... Bad situation. We would have invalidate_start take
a lock to prevent registration until _end has run.

We could use stop_machine_run to register the notifier.... ;-).

