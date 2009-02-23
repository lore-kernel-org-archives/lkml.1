Return-Path: <linux-kernel-owner+w=401wt.eu-S1755698AbZBWVrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbZBWVrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 16:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbZBWVrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 16:47:04 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16830 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbZBWVrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 16:47:03 -0500
Date: Mon, 23 Feb 2009 22:46:19 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Paul Menage <menage@google.com>
cc: linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Paul Jackson <pj@sgi.com>, Simon Derr <simon.derr@bull.net>
Subject: Re: [PATCH] Remove some pointless conditionals before kfree() in 
 kernel/cgroup.c
In-Reply-To: <6599ad830902230012x170e2183q1540670d761ef80e@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.0902232241180.28481@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.0902222254350.1236@swampdragon.chaosbits.net> <6599ad830902230012x170e2183q1540670d761ef80e@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009, Paul Menage wrote:

> On Sun, Feb 22, 2009 at 2:05 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> > Hi,
> >
> > Here's a small patch for kernel/cgroup.c
> >
> > Removes a few pointless tests of pointer == 0 before kfree() in
> > kernel/cgroup.c.
> > If the pointer we hand to kfree() is 0, then kfree() is a noop, so there
> > is no need to test.
> >
> > Reduces object file size a bit :
> >
> > Before:
> > $ size kernel/cgroup.o
> >   text    data     bss     dec     hex filename
> >  21593    7804    4924   34321    8611 kernel/cgroup.o
> > After:
> > $ size kernel/cgroup.o
> >   text    data     bss     dec     hex filename
> >  21537    7744    4924   34205    859d kernel/cgroup.o
> 
> Thanks. I'm a bit surprised that it also shrunk the data segment size
> (and in fact, by more than the text segment size). Any idea how that
> came about?
> 
Can't say I've got a good explanation for that, no.

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

