Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbYFUOBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbYFUOBp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 10:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbYFUOBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 10:01:34 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:34142 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbYFUOAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 10:00:51 -0400
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       AntonioLin <antonio.lin@alcormicro.com>,
       David Vrabel <david.vrabel@csr.com>
Subject: Re: Scatter-gather list constraints
From: Andi Kleen <andi@firstfloor.org>
References: <Pine.LNX.4.44L0.0806201623080.2133-100000@iolanthe.rowland.org>
Date: Sat, 21 Jun 2008 15:59:51 +0200
In-Reply-To: <Pine.LNX.4.44L0.0806201623080.2133-100000@iolanthe.rowland.org> (Alan Stern's message of "Fri, 20 Jun 2008 16:30:25 -0400 (EDT)")
Message-ID: <87fxr6yjl4.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Jun 2008 13:52:36.0414 (UTC) FILETIME=[0FDB95E0:01C8D3A6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> This question arises in connection with wireless USB mass-storage
> devices.  The controller driver requires that all DMA segments
> in a transfer, other than the last one, have a multiple of 1024 bytes.  
> But we're sometimes getting s-g lists where an element contains an odd
> number of 512-byte sectors, and of course it doesn't work.

But you can handle a single 512 byte request? Splitting the request
in this case should work. Or maybe copying is cheaper than splitting?

I don't think the block layer knows about such kinds of restrictions.

-Andi
