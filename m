Return-Path: <linux-kernel-owner+w=401wt.eu-S1763266AbXF0Tc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763266AbXF0Tc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 15:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757046AbXF0Tck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 15:32:40 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:54856 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763057AbXF0Tcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 15:32:39 -0400
Date: Wed, 27 Jun 2007 20:32:04 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Ulrich Drepper <drepper@gmail.com>
cc: Davide Libenzi <davidel@xmailserver.org>, blaisorblade@yahoo.it,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/3] MAP_NOZERO - implement sys_brk2()
In-Reply-To: <a36005b50706271152o2ba87c69h99c51a3605f977ae@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706272027100.2367@blonde.wat.veritas.com>
References: <send-serie.davidel@xmailserver.org.29496.1182912260.2> 
 <a36005b50706262048y5eb8ba80kb0d852d649d1ac10@mail.gmail.com> 
 <Pine.LNX.4.64.0706262052060.26540@alien.or.mcafeemobile.com> 
 <a36005b50706262202w4aaa4494qc2322e49c71d8d7c@mail.gmail.com> 
 <Pine.LNX.4.64.0706271309500.26951@blonde.wat.veritas.com> 
 <a36005b50706271001o191f3e24n83b25988739429fb@mail.gmail.com> 
 <Pine.LNX.4.64.0706271807330.22337@blonde.wat.veritas.com>
 <a36005b50706271152o2ba87c69h99c51a3605f977ae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABGluYm94AGJsYWlzb3JibGFkZUB5YWhvby5pdABkYXZpZGVsQHhtYWlsc2VydmVyLm9yZwBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnAGRyZXBwZXJAZ21haWwuY29tAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007, Ulrich Drepper wrote:
> On 6/27/07, Hugh Dickins <hugh@veritas.com> wrote:
> > The absolute virtual addresses are randomized, yes; but do a sequence
> > of mmaps and they come back adjacent to each other, and so mergable.
> > Or does your distro include a kernel patch to randomize them relative
> > to each other?
> 
> Each individual mmap is supposed to be randomized, yes.  If this
> doesn't happen in one of our kernels right now something broken.  You
> wouldn't have effective ASLR if all relative address remain the same.

Ah, I guess it's an exec_shield thing: vanilla kernel gives us
adjacent mmaps which are mergable.  As Rik suggest, to make your
mmaps adjacent, use the mmap(addr,...) hint.  (But please don't
then complain that they're not relatively randomized ;)

> > It _might_ turn out to be more attractive, not to rely on that
> > peculiar sys_remap_file_pages, but make all our vmas independent
> > of protections, and hang differently protected ranges off them.
> > Maybe.
> 
> That's what I think is done or at least should be done.

Noted.

Hugh
