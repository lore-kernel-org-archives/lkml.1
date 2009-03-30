Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbZC3MO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbZC3MO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 08:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbZC3MOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:14:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44838 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbZC3MOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:14:16 -0400
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 12/14] fs: dcache per-bucket dcache hash locking
From: Andi Kleen <andi@firstfloor.org>
References: <20090329155539.275927173@nick.local0.net>
	<20090329155750.062096365@nick.local0.net>
Date: Mon, 30 Mar 2009 14:14:08 +0200
In-Reply-To: <20090329155750.062096365@nick.local0.net> (npiggin@suse.de's message of "Mon, 30 Mar 2009 02:55:51 +1100")
Message-ID: <878wmnnr73.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

npiggin@suse.de writes:

> We can turn the dcache hash locking from a global dcache_hash_lock into
> per-bucket locking.

Per bucket locking is typically a bad idea because you get far too
many locks and you increase cache footprint with all of them. It's
typically better to use a second much smaller hash table that only has
locks (by just shifting the hash value down some more) 
Just need to be careful to avoid too much false sharing.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
