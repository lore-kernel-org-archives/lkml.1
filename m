Return-Path: <linux-kernel-owner+w=401wt.eu-S1756982AbYAXUIC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbYAXUIC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:08:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbYAXUHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:07:53 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54330 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754141AbYAXUHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:07:53 -0500
Date: Thu, 24 Jan 2008 12:07:52 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, Andrew Morton <akpm@osdl.org>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [kvm-devel] [PATCH] export notifier #1
In-Reply-To: <20080124154239.GP7141@v2.random>
Message-ID: <Pine.LNX.4.64.0801241205510.22285@schroedinger.engr.sgi.com>
References: <4795F9D2.1050503@qumranet.com> <20080122144332.GE7331@v2.random>
 <20080122200858.GB15848@v2.random> <Pine.LNX.4.64.0801221232040.28197@schroedinger.engr.sgi.com>
 <20080122223139.GD15848@v2.random> <Pine.LNX.4.64.0801221433080.2271@schroedinger.engr.sgi.com>
 <20080123114136.GE15848@v2.random> <20080123123230.GH26420@sgi.com>
 <20080123173325.GG7141@v2.random> <Pine.LNX.4.64.0801231220590.13547@schroedinger.engr.sgi.com>
 <20080124154239.GP7141@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2008, Andrea Arcangeli wrote:

> I think you should consider if you can also build a rmap per-MM like
> KVM does and index it by the virtual address like KVM does.

Yes we have that.

If we have that then we do not need the mmu_notifier. 
We could call it with a page parameter and then walk the KVM or XPmem 
reverse map to directly find all the ptes we need to clear. There is no 
need then to add a new field to the mm_struct.

