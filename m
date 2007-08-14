Return-Path: <linux-kernel-owner+w=401wt.eu-S932742AbXHNUpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932742AbXHNUpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 16:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758765AbXHNUo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 16:44:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41737 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763533AbXHNUo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 16:44:56 -0400
Date: Tue, 14 Aug 2007 22:44:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/9] Atomic reclaim: Save irq flags in vmscan.c
Message-ID: <20070814204454.GC22202@one.firstfloor.org>
References: <20070814153021.446917377@sgi.com> <20070814153501.766137366@sgi.com> <p73vebhnauo.fsf@bingen.suse.de> <Pine.LNX.4.64.0708141209270.29498@schroedinger.engr.sgi.com> <20070814203329.GA22202@one.firstfloor.org> <Pine.LNX.4.64.0708141341120.31513@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708141341120.31513@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmmmm... The spinlock is its own flag.

Yes, but it's not CPU local. Taking the spinlock from another CPU's
interrupt handler is perfectly safe, just not from the local CPU.
If you use the spinlock as flag you would need to lock out everybody.

-Andi
