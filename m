Return-Path: <linux-kernel-owner+w=401wt.eu-S932230AbXBSNfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230AbXBSNfG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 08:35:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932235AbXBSNfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 08:35:06 -0500
Received: from brick.kernel.dk ([62.242.22.158]:15243 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932230AbXBSNfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 08:35:03 -0500
Date: Mon, 19 Feb 2007 14:34:53 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mattia Dongili <malattia@linux.it>,
       Laurent Riffard <laurent.riffard@free.fr>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] fix locking in __make_request (was Re: 2.6.20-mm2: Oops in generic_make_request)
Message-ID: <20070219133453.GL17728@kernel.dk>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org> <45D84F73.8060904@free.fr> <20070218175805.GB5567@inferi.kami.home> <20070218114903.a8160301.akpm@linux-foundation.org> <6bffcb0e0702181205v5755fc0es284c5be32f85d304@mail.gmail.com> <20070220130408.GB566@slug>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220130408.GB566@slug>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20 2007, Frederik Deweerdt wrote:
> On Sun, Feb 18, 2007 at 09:05:33PM +0100, Michal Piotrowski wrote:
> > On 18/02/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > >On Sun, 18 Feb 2007 18:58:05 +0100 Mattia Dongili <malattia@linux.it> wrote:
> > >
> > >> On Sun, Feb 18, 2007 at 02:06:59PM +0100, Laurent Riffard wrote:
> > >> > Le 18.02.2007 06:51, Andrew Morton a ?crit :
> > >> > >Temporarily at
> > >> > >
> > >> > >  http://userweb.kernel.org/~akpm/2.6.20-mm2/
> > >> > >
> > >> > >Will appear later at
> > >> > >
> > >> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/
> > >> >
> > >> > Hello, I've got a fully reproducible Oops. I just have to boot to
> > >> > runlevel 2 and wait less than one minute.
> > >>
> > >> Maybe this oops is related too?
> > >
> > >Looks that way.
> > >
> Hi Michal,
> 
> This seems to be a locking problem in __make_request, check_plug_merge()
> should be called with the q->queue_lock held.
> Could you try the following patch? It silenced the oops for me.

Just back from travel... That is not correct, why do you think the queue
lock needs to be held there? I'll look into this tomorrow.

-- 
Jens Axboe

