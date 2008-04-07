Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbYDGFpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbYDGFpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 01:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbYDGFpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 01:45:44 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34200 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751088AbYDGFpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 01:45:44 -0400
Date: Sun, 6 Apr 2008 22:45:41 -0700 (PDT)
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
Subject: Re: [PATCH] mmu notifier #v11
In-Reply-To: <20080405002330.GF14784@duo.random>
Message-ID: <Pine.LNX.4.64.0804062244110.18148@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0804021048460.27214@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0804021402190.30337@schroedinger.engr.sgi.com>
 <20080402220148.GV19189@duo.random> <Pine.LNX.4.64.0804021503320.31247@schroedinger.engr.sgi.com>
 <20080402221716.GY19189@duo.random> <Pine.LNX.4.64.0804021821230.639@schroedinger.engr.sgi.com>
 <20080403151908.GB9603@duo.random> <Pine.LNX.4.64.0804031215050.7480@schroedinger.engr.sgi.com>
 <20080404202055.GA14784@duo.random> <Pine.LNX.4.64.0804041504310.12396@schroedinger.engr.sgi.com>
 <20080405002330.GF14784@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Apr 2008, Andrea Arcangeli wrote:

> In short when working with single pages it's a waste to block the
> secondary-mmu page fault, because it's zero cost to invalidate_page
> before put_page. Not even GRU need to do that.

That depends on what the notifier is being used for. Some serialization 
with the external mappings has to be done anyways. And its cleaner to have 
one API that does a lock/unlock scheme. Atomic operations can easily lead
to races.

