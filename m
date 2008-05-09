Return-Path: <linux-kernel-owner+w=401wt.eu-S1757843AbYEIVDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843AbYEIVDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 17:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbYEIVDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 17:03:22 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48705 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753215AbYEIVDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 17:03:21 -0400
Date: Fri, 9 May 2008 14:03:19 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Russ Anderson <rja@sgi.com>
cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 3/3] ia64: Call migration code on correctable errors v3
In-Reply-To: <20080509151135.GD16523@sgi.com>
Message-ID: <Pine.LNX.4.64.0805091358160.20375@schroedinger.engr.sgi.com>
References: <20080509151135.GD16523@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2008, Russ Anderson wrote:

> +	local_irq_save(irq_flags);

The page migration functions expect to be called in non atomic contexts 
since they use things like lock_page(). Can you just drop the irq disable? 
The spinlock should not be there either. Page migration serialize via 
the LRU. Pages that are to be migrated have to be taken off the LRU 
first. There is no danger of two threads trying to migrate the same 
page because the second one will not be able to take it off the LRU 
anymore.



