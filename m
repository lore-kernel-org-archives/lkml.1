Return-Path: <linux-kernel-owner+w=401wt.eu-S1762208AbZDHGNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762208AbZDHGNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 02:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757808AbZDHGN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 02:13:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34877 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704AbZDHGN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 02:13:26 -0400
Date: Wed, 8 Apr 2009 08:15:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH] [0/16] POISON: Intro
Message-ID: <20090408061539.GD17934@one.firstfloor.org>
References: <20090407509.382219156@firstfloor.org> <20090407221542.91cd3c42.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090407221542.91cd3c42.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 10:15:42PM -0700, Andrew Morton wrote:
> On Tue,  7 Apr 2009 17:09:56 +0200 (CEST) Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Upcoming Intel CPUs have support for recovering from some memory errors. This
> > requires the OS to declare a page "poisoned", kill the processes associated
> > with it and avoid using it in the future. This patchkit implements
> > the necessary infrastructure in the VM.
> 
> If the page is clean then we can just toss it and grab a new one from
> backing store without killing anyone.
> 
> Does the patchset do that?

Yes. But it only really works for shared mmap, anonymous and private
tends to be near always dirty.

Also you can disable even the early kill and only request kill
on access.

It also does some other tricks, like for dirty file just trigger
an IO error (although I must admit the dirty handling is rather
tricky and I would appreciate very careful review of that part)s

A few other known recovery tricks are not implemented yet
(like handling free memory[1]), but will be over time.

-Andi

[1] I didn't consider that one high priority since production
systems with long uptime shouldn't have much free memory.

-- 
ak@linux.intel.com -- Speaking for myself only.
