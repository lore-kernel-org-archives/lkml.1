Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbYJGXlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbYJGXlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 19:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYJGXlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 19:41:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40103 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754741AbYJGXlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 19:41:06 -0400
Date: Wed, 8 Oct 2008 00:40:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Hugh Dickins <hugh@veritas.com>, Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, v3] shmat: introduce flag SHM_MAP_NOT_FIXED
Message-ID: <20081008004030.7a0e9915@lxorguk.ukuu.org.uk>
In-Reply-To: <20081007232059.GU20740@one.firstfloor.org>
References: <1223396117-8118-1-git-send-email-kirill@shutemov.name>
	<2f11576a0810070931k79eb72dfr838a96650563b93a@mail.gmail.com>
	<20081007211038.GQ20740@one.firstfloor.org>
	<20081008000518.13f48462@lxorguk.ukuu.org.uk>
	<20081007232059.GU20740@one.firstfloor.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Can use shm_open and mmap to get POSIX standard shm behaviour via a sane
> 
> I don't think shm_open can attach to SYSV shared segments. Or are you
> proposing to add "sysvshmfs" to make that possible? 

Actually you can do so. As it stands today the SYS3 SHM interface code
does the following

	create a char array in the form SYS%08ld, key
	open it on shmfs

> - There are legacy interfaces that cannot be really changed who use sysv shm
> (e.g. X shm and others -- just do a ipcs on your system) 

They can be changed and nobody is wanting to map those at fixed addresses.

> - An system call emulation as in qemu obviously has to implement the
> existing system call semantics.

Which it can do perfectly well using shm_open to create its SYS3
SHM objects. In fact theoertically we could bin the whole of SYS3 shm and
push it into glibc emulation if we wanted.

Alan
