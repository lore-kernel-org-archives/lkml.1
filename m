Return-Path: <linux-kernel-owner+w=401wt.eu-S1762471AbYDVI7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762471AbYDVI7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 04:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757764AbYDVI7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 04:59:17 -0400
Received: from hu-out-0506.google.com ([72.14.214.233]:54664 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757616AbYDVI7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 04:59:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=WYFMWvJ+uVtDzO5AtqKMjwjP6DL21+zSaGiWAryBf3OvdaRdlVYr+BcqVzIbCiEvesgMQWceialmpmPQ2W2PzLvV1uw9O7GECc54UaMT0zz2rMtQstBvQXER22Jzt/fslIadXVKs8m4X9LuSoQLQ3R/t5tlG6paD9zfMeRKAwTE=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs: do not pass unused params to xfs_flush_pages
Date: Tue, 22 Apr 2008 10:57:33 +0200
User-Agent: KMail/1.8.2
Cc: David Chinner <dgc@sgi.com>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080419142329.GA5339@elte.hu> <200804220503.16888.vda.linux@googlemail.com> <480D586C.1030305@sandeen.net>
In-Reply-To: <480D586C.1030305@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804221057.33324.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 April 2008 05:15, Eric Sandeen wrote:
> Denys Vlasenko wrote:
> > Hi David,
> > 
> > xfs_flush_pages() does not use some of its parameters, namely:
> > first, last and fiops.
> > 
> > This patch removes these parameters from all callsites.
> > 
> > Code size difference on 32-bit x86:
> > 
> >    text    data     bss     dec     hex filename
> >  390739    2748    1708  395195   607bb linux-2.6-xfs1-TEST/fs/xfs/xfs.o
> >  390567    2748    1708  395023   6070f linux-2.6-xfs2-TEST/fs/xfs/xfs.o
> > 
> > Compile-tested only.
> 
> FWIW this one actually does not seem to reduce stack usage anywhere.

I hope this will not deteriorate into a contest whether
every particular patch reduces stack usage or not, but:

You do not see reduced stack usage in "make checkstack",
because "make checkstack" shows only stack usage caused by
local variables (it analyses sub %esp,NN instructions which
make room for them). Parameters also take up stack, but
they are pushed on stack with push instruction,
and so are invisible in "make checkstack" output.
--
vda
