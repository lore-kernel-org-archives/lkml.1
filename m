Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbZKLPdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbZKLPdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 10:33:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbZKLPdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 10:33:49 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:46982 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbZKLPds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 10:33:48 -0500
Date: Thu, 12 Nov 2009 16:33:52 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Bernd Petrovitsch <bernd@firmix.at>
Cc: al@alarsen.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: sizeof vs strlen (was Re: [PATCH 4/4] fs/qnx4: decrement sizeof
 size in strncmp)
In-Reply-To: <1258021335.3689.41.camel@tara.firmix.at>
Message-ID: <Pine.LNX.4.64.0911121632540.19779@ask.diku.dk>
References: <Pine.LNX.4.64.0911120849260.16627@ask.diku.dk>
 <1258021335.3689.41.camel@tara.firmix.at>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009, Bernd Petrovitsch wrote:

> On Thu, 2009-11-12 at 08:49 +0100, Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > As observed by Joe Perches, sizeof of a constant string includes the
> > trailing 0.  If what is wanted is to check the initial characters of
> > another string, this trailing 0 should not be taken into account.  If an
> > exact match is wanted, strcmp should be used instead.
> [...]
> > strncmp(foo, abc, 
> > - sizeof(abc)
> > + sizeof(abc)-1
> >  )
> > // </smpl>
> Am I the only one who find "strlen()" instead of "sizeof()-1" here much
> more readable (and to the point).
> 
> As for run-time, it shouldn't make a difference for static/constant
> strings as gcc should be able calculate the length at compile time. And
> if the string is not constant, sizeof() is probably wrong anyways.

Does gcc have access to the definition of strlen?  It does not seem to be 
an inlined function, eg in lib/string.c.

julia
