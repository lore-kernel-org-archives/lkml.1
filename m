Return-Path: <linux-kernel-owner+w=401wt.eu-S933230AbYCDTAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230AbYCDTAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 14:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762468AbYCDTAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 14:00:38 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43966 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762605AbYCDTAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 14:00:37 -0500
Date: Tue, 4 Mar 2008 11:00:31 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Jack Steiner <steiner@sgi.com>, Nick Piggin <npiggin@suse.de>,
       akpm@linux-foundation.org, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [RFC] Notifier for Externally Mapped Memory (EMM)
In-Reply-To: <20080304133020.GC5301@v2.random>
Message-ID: <Pine.LNX.4.64.0803041059110.13957@schroedinger.engr.sgi.com>
References: <20080220103942.GU7128@v2.random> <20080221045430.GC15215@wotan.suse.de>
 <20080221144023.GC9427@v2.random> <20080221161028.GA14220@sgi.com>
 <20080227192610.GF28483@v2.random> <20080302155457.GK8091@v2.random>
 <20080303213707.GA8091@v2.random> <20080303220502.GA5301@v2.random>
 <47CC9B57.5050402@qumranet.com> <Pine.LNX.4.64.0803032327470.9642@schroedinger.engr.sgi.com>
 <20080304133020.GC5301@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008, Andrea Arcangeli wrote:

> When working with single pages it's more efficient and preferable to
> call invalidate_page and only later release the VM reference on the
> page.

But as you pointed out before that path is a slow path anyways. Its rarely 
taken. Having a single eviction callback simplifies design.

Plus the device driver can still check if the mapping was of PAGE_SIZE and 
then implement its own optimization.
 
