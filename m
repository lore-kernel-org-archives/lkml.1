Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128AbZBIO6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbZBIO6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 09:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbZBIO6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 09:58:01 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:25442 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbZBIO6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 09:58:00 -0500
Subject: Re: Build failure with latest -git: btrfs on ppc64
From: Chris Mason <chris.mason@oracle.com>
To: Kyle McMartin <kyle@infradead.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090207232458.GB23407@bombadil.infradead.org>
References: <20090207155039.3b6a7429@dhcp-100-2-144.bos.redhat.com>
	 <20090207232458.GB23407@bombadil.infradead.org>
Content-Type: text/plain
Date: Mon, 09 Feb 2009 09:57:26 -0500
Message-Id: <1234191446.1262.3.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4990445A.02BC:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-07 at 18:24 -0500, Kyle McMartin wrote:
> On Sat, Feb 07, 2009 at 03:50:39PM -0500, Chuck Ebbert wrote:
> > fs/btrfs/locking.c: In function 'btrfs_path_lock_waiting':
> > fs/btrfs/locking.c:254: error: implicit declaration of function '__raw_spin_is_contended'
> > 
> > Looks like spin_is_contended() is only available on mips and x86??
> > 
> 
> Looks to be if there are other folks in line for the ticket lock.
> 
> Arguably this should probably be something silly in spinlock.h like,
> 
> #ifndef __raw_spin_is_contended
> # define spin_is_contended (0)
> #else
> # define spin_is_contended(x) __raw_spin_is_contended((x))
> #endif
> 
> or something since in theory anybody has a chance of acquiring it next
> (well, lies because caches bias, but there's no waiters at least.)
> 
> Either that, or we just define it to be spin_is_locked if the assumption
> is that the lock will continue to be locked...

Ok, I thought this would be defined to something simple for the
non-ticket users, should I just not be using this call?  

-chris


