Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046AbXH2JW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbXH2JW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 05:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbXH2JWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 05:22:48 -0400
Received: from web32603.mail.mud.yahoo.com ([68.142.207.230]:30230 "HELO
	web32603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753081AbXH2JWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 05:22:48 -0400
X-YMail-OSG: mcVQhAYVM1mmOkEm1lTejUs6vn6bRAW4S5AE339cZKkJWIUtfTLJ2sOcnD_j5YMceudtGlxIBIS3SQ97REllUdd4UQ--
X-RocketYMMF: knobi.rm
Date: Wed, 29 Aug 2007 02:22:47 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Reply-To: spamtrap@knobisoft.de
Subject: Re: Understanding I/O behaviour - next try
To: Fengguang Wu <wfg@mail.ustc.edu.cn>,
       Martin Knoblauch <spamtrap@knobisoft.de>
Cc: linux-kernel@vger.kernel.org, Peter zijlstra <a.p.zijlstra@chello.nl>,
       mingo@redhat.com
In-Reply-To: <388376840.29283@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <377365.93295.qm@web32603.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:

> On Wed, Aug 29, 2007 at 01:15:45AM -0700, Martin Knoblauch wrote:
> > 
> > --- Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> > 
> > > You are apparently running into the sluggish kupdate-style
> writeback
> > > problem with large files: huge amount of dirty pages are getting
> > > accumulated and flushed to the disk all at once when dirty
> background
> > > ratio is reached. The current -mm tree has some fixes for it, and
> > > there are some more in my tree. Martin, I'll send you the patch
> if
> > > you'd like to try it out.
> > >
> > Hi Fengguang,
> > 
> >  Yeah, that pretty much describes the situation we end up. Although
> > "sluggish" is much to friendly if we hit the situation :-)
> > 
> >  Yes, I am very interested  to check out your patch. I saw your
> > postings on LKML already and was already curious. Any chance you
> have
> > something agains 2.6.22-stable? I have reasons not to move to -23
> or
> > -mm.
> 
> Well, they are a dozen patches from various sources.  I managed to
> back-port them. It compiles and runs, however I cannot guarantee
> more...
>

 Thanks. I understand the limited scope of the warranty :-) I will give
it a spin today.
 
> > > >  Another thing I saw during my tests is that when writing to
> NFS,
> > > the
> > > > "dirty" or "nr_dirty" numbers are always 0. Is this a
> conceptual
> > > thing,
> > > > or a bug?
> > > 
> > > What are the nr_unstable numbers?
> > >
> > 
> >  Ahh. Yes, they go up to 80-90k pages. Comparable to the nr_dirty
> > numbers for the disk case. Good to know.
> > 
> >  For NFS, the nr_writeback numbers seem surprisingly high. They
> also go
> > to 80-90k (pages ?). In the disk case they rarely go over 12k.
> 
> Maybe the difference of throttling one single 'cp' and a dozen
> 'nfsd'?
>

 No "nfsd" running on that box. It is just a client.

Cheers
Martin
 

------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
