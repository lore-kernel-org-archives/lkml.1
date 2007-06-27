Return-Path: <linux-kernel-owner+w=401wt.eu-S1762457AbXF0Swi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762457AbXF0Swi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 14:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758206AbXF0Sw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 14:52:29 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:34391 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757662AbXF0Sw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 14:52:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=J5jb/YxzcHPpUOUBCescIRrWvukcCyWe1A1IPdCyb10QjhxFlYnVi8lcNgr+8pFZVxM6dNMLt0L9klLUtuIx8tW5VH59fzacmZ2egeN3WHTIgD9q/hW6bHmtxWCeB7yEdQaImiJAoJn1RFv2GA1VRl/RifkiJOJH2hYp6Yk0w5Y=
Message-ID: <a36005b50706271152o2ba87c69h99c51a3605f977ae@mail.gmail.com>
Date: Wed, 27 Jun 2007 11:52:27 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: [patch 2/3] MAP_NOZERO - implement sys_brk2()
Cc: "Davide Libenzi" <davidel@xmailserver.org>, blaisorblade@yahoo.it,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706271807330.22337@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <send-serie.davidel@xmailserver.org.29496.1182912260.2>
	 <a36005b50706262048y5eb8ba80kb0d852d649d1ac10@mail.gmail.com>
	 <Pine.LNX.4.64.0706262052060.26540@alien.or.mcafeemobile.com>
	 <a36005b50706262202w4aaa4494qc2322e49c71d8d7c@mail.gmail.com>
	 <Pine.LNX.4.64.0706271309500.26951@blonde.wat.veritas.com>
	 <a36005b50706271001o191f3e24n83b25988739429fb@mail.gmail.com>
	 <Pine.LNX.4.64.0706271807330.22337@blonde.wat.veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/27/07, Hugh Dickins <hugh@veritas.com> wrote:
> The absolute virtual addresses are randomized, yes; but do a sequence
> of mmaps and they come back adjacent to each other, and so mergable.
> Or does your distro include a kernel patch to randomize them relative
> to each other?

Each individual mmap is supposed to be randomized, yes.  If this
doesn't happen in one of our kernels right now something broken.  You
wouldn't have effective ASLR if all relative address remain the same.


> It _might_ turn out to be more attractive, not to rely on that
> peculiar sys_remap_file_pages, but make all our vmas independent
> of protections, and hang differently protected ranges off them.
> Maybe.

That's what I think is done or at least should be done.

If you want to be shocked, look at some really big Java apps.
Hundreds or thousands of threads, lots of mmap allocation.  We might
have 10,000 VMAs.  Searching becomes a problem and if the protection
information be stored somewhere else and you safe the VMA data
structures there is even some memory saving possible.

I definitely thing that this is an area which warrants looking at.  We
haven't yet seen the worst of VMA usage.  The move to 64-bit is only
just beginning and wait what people think they can do with 48+ bits of
address space.
