Return-Path: <linux-kernel-owner+w=401wt.eu-S1757593AbYAVXiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbYAVXiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 18:38:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbYAVXhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 18:37:53 -0500
Received: from gate.crashing.org ([63.228.1.57]:40075 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbYAVXhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 18:37:52 -0500
Subject: Re: [kvm-devel] [PATCH] export notifier #1
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, Andrew Morton <akpm@osdl.org>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, holt@sgi.com,
       Hugh Dickins <hugh@veritas.com>
In-Reply-To: <Pine.LNX.4.64.0801221232040.28197@schroedinger.engr.sgi.com>
References: <20080113162418.GE8736@v2.random>
	 <20080116124256.44033d48@bree.surriel.com> <478E4356.7030303@qumranet.com>
	 <20080117162302.GI7170@v2.random> <478F9C9C.7070500@qumranet.com>
	 <20080117193252.GC24131@v2.random> <20080121125204.GJ6970@v2.random>
	 <4795F9D2.1050503@qumranet.com> <20080122144332.GE7331@v2.random>
	 <20080122200858.GB15848@v2.random>
	 <Pine.LNX.4.64.0801221232040.28197@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Wed, 23 Jan 2008 10:36:29 +1100
Message-Id: <1201044989.6807.46.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-22 at 12:34 -0800, Christoph Lameter wrote:
> 
> - Notifiers are called *after* we tore down ptes. At that point pages
>   may already have been freed and reused. This means that there can
>   still be uses of the page by the user of mmu_ops after the OS has
>   dropped its mapping. IMHO the foreign entity needs to drop its
>   mappings first. That also ensures that the entities operated
>   upon continue to exist.

That's definitely an issue. Maybe having the foreign entity get a
reference to the page and drop it when it unmaps would help ?

> - anon_vma/inode and pte locks are held during callbacks.

So how does that fix the problem of sleeping then ?

Ben.


