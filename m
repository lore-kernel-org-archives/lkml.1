Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbYJHK4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbYJHK4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 06:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbYJHK4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 06:56:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57479 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbYJHK4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:56:35 -0400
Date: Wed, 8 Oct 2008 13:02:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Hugh Dickins <hugh@veritas.com>, Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, v3] shmat: introduce flag SHM_MAP_NOT_FIXED
Message-ID: <20081008110243.GN7971@one.firstfloor.org>
References: <20081007211038.GQ20740@one.firstfloor.org> <20081008000518.13f48462@lxorguk.ukuu.org.uk> <20081007232059.GU20740@one.firstfloor.org> <20081008004030.7a0e9915@lxorguk.ukuu.org.uk> <20081007235737.GD7971@one.firstfloor.org> <20081008093424.4e88a3c2@lxorguk.ukuu.org.uk> <20081008084350.GI7971@one.firstfloor.org> <20081008095851.01790b6a@lxorguk.ukuu.org.uk> <20081008091112.GK7971@one.firstfloor.org> <20081008112037.6fa37c0b@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081008112037.6fa37c0b@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2008 at 11:20:37AM +0100, Alan Cox wrote:
> > That is racy when multi threaded because shmat() doesn't replace, so you 
> > would need to munmap() inbetween and someone else could steal the area
> > then. Yes you could stick a loop around it. It could livelock.
> > No, it's not a good interface I would advocate.
> 
> You could just use pthread mutexes in your application. The rôle of the

malloc() can call mmap, so that would require putting a mutex around
each malloc(). Good luck finding them all.

> kernel is not to provide nappies for people who think programming is too
> hard but to provide services that can be used to build applications.

Outsourcing kernel locking to user space is not the way to go.

-Andi

-- 
ak@linux.intel.com
