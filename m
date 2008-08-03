Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbYHCCnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbYHCCnw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 22:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbYHCCnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 22:43:45 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:45027 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbYHCCno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 22:43:44 -0400
Date: Sat, 2 Aug 2008 20:43:28 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Keith Owens <kaos@ocs.com.au>
Cc: Simon Horman <horms@verge.net.au>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>
Subject: Re: [patch] IA64: suppress return value of down_trylock() in salinfo_work_to_do()
Message-ID: <20080803024327.GE26461@parisc-linux.org>
References: <20080803013159.GB26461@parisc-linux.org> <12597.1217729288@ocs10w>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12597.1217729288@ocs10w>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2008 at 12:08:08PM +1000, Keith Owens wrote:
> >task A acquires sem
> >
> >task B tries to acquire the sem, fails
> >task B releases the sem that it didn't acquire
> >
> >task A releases the sem, falls down, goes boom?
> 
> Cannot happen.  See the comment above the function:
> 
>   This routine must be called with data_saved_lock held, to make the down/up
>   operation atomic

... that requres one to know that salinfo_work_to_do() is the only place
which calls up() (and it always calls down_trylock first).  This is a
really creative misuse of semaphores.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
