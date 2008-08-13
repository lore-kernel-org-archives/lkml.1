Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbYHMIQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbYHMIQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbYHMIPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:15:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbYHMIPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:15:47 -0400
Date: Wed, 13 Aug 2008 10:15:44 +0200
From: Karel Zak <kzak@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: util-linux-ng@vger.kernel.org, Archie Cobbs <archie@dellroad.org>
Subject: Re: [PATCH] losetup: add option for O_DIRECT
Message-ID: <20080813081544.GA6070@nb.net.home>
References: <3bc8237c0808121426m6fada313r33ed4c419386a1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bc8237c0808121426m6fada313r33ed4c419386a1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 04:26:10PM -0500, Archie Cobbs wrote:
> On Thu, Aug 7, 2008 at 1:26 PM, Archie Cobbs <archie@dellroad.org> wrote:
> > I have an application involving the loopback device where it would be
> > valuable for the underlying file to be opened with the O_DIRECT flag.
> >
> > Any thoughts one way or the other about adding support to losetup(8)
> > and mount(8) for a 'direct' option that would enable this?
> >
> > I will propose a patch if people think this would be a reasonable thing to do.
> 
> Add support for opening loopback files with O_DIRECT.
[...]

>         mode = (*options & SETLOOP_RDONLY) ? O_RDONLY : O_RDWR;
> +       if (*options & SETLOOP_DIRECT)
> +               mode |= O_DIRECT;
>         if ((ffd = open(file, mode)) < 0) {


 Do you remember  http://lkml.org/lkml/2007/1/10/233  ?

 .. use O_DIRECT for files is BAD idea (and loop device is nothing
 other than a file on standard FS).

 I'm really not sure if we want to support this feature. I'm also not
 sure if kernel loop device code is ready for O_DIRECT. (BTW, O_DIRECT
 reads and writes must be aligned, ...)

 Sorry, but I have to see ACK/NACK from relevant kernel person.
 Redirecting to lkml.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
