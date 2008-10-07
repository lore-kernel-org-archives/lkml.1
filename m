Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbYJGXvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbYJGXvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 19:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbYJGXva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 19:51:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43087 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbYJGXv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 19:51:29 -0400
Date: Wed, 8 Oct 2008 01:57:37 +0200
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
Message-ID: <20081007235737.GD7971@one.firstfloor.org>
References: <1223396117-8118-1-git-send-email-kirill@shutemov.name> <2f11576a0810070931k79eb72dfr838a96650563b93a@mail.gmail.com> <20081007211038.GQ20740@one.firstfloor.org> <20081008000518.13f48462@lxorguk.ukuu.org.uk> <20081007232059.GU20740@one.firstfloor.org> <20081008004030.7a0e9915@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081008004030.7a0e9915@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2008 at 12:40:30AM +0100, Alan Cox wrote:
> > > Can use shm_open and mmap to get POSIX standard shm behaviour via a sane
> > 
> > I don't think shm_open can attach to SYSV shared segments. Or are you
> > proposing to add "sysvshmfs" to make that possible? 
> 
> Actually you can do so. As it stands today the SYS3 SHM interface code
> does the following
> 
> 	create a char array in the form SYS%08ld, key
> 	open it on shmfs

Perhaps I'm confused but my /dev/shm doesn't have any such files,
but I see a variety of shm segments in ipcs.

What would the path passed to shm_open look like?

> 
> > - There are legacy interfaces that cannot be really changed who use sysv shm
> > (e.g. X shm and others -- just do a ipcs on your system) 
> 
> They can be changed 

You want to break the X interface? And who knows who else
is using it.

> and nobody is wanting to map those at fixed addresses.

You're saying it should always use the address as a search hint?

Just changing the semantics unconditionally would seem risky to me. After 
all as you point out they are primarily for compatibility and for that keeping
old semantics would seem better to me.

-Andi
-- 
ak@linux.intel.com
