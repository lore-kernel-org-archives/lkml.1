Return-Path: <linux-kernel-owner+w=401wt.eu-S1756963AbZLLHXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963AbZLLHXB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 02:23:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754951AbZLLHW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 02:22:59 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:48748 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbZLLHW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 02:22:59 -0500
Date: Sat, 12 Dec 2009 08:21:58 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       samr@ravnborg.org
Subject: Re: hwrng: virtio - Rename driver object to remove section
	mismatch warning
Message-ID: <20091212072158.GA9681@merkur.ravnborg.org>
References: <20091211153658.GA1207@gondor.apana.org.au> <1260559557.24459.1320.camel@calx> <20091211120849.012c43d8.randy.dunlap@oracle.com> <20091212002148.GA9586@merkur.ravnborg.org> <1260577997.24459.1405.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260577997.24459.1405.camel@calx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 06:33:17PM -0600, Matt Mackall wrote:
> On Sat, 2009-12-12 at 01:21 +0100, Sam Ravnborg wrote:
> > On Fri, Dec 11, 2009 at 12:08:49PM -0800, Randy Dunlap wrote:
> > > On Fri, 11 Dec 2009 13:25:57 -0600 Matt Mackall wrote:
> > > 
> > > > On Fri, 2009-12-11 at 23:36 +0800, Herbert Xu wrote:
> > > > > Hi:
> > > > > 
> > > > > Finally found the cause of the section mismatch warning in hwrng.
> > > > > Apparently in addition to __devexit_p we now have to name the
> > > > > variable in a certain way.
> > > > 
> > > > That's fairly appalling. Any idea why?
> > > 
> > > (I haven't read the rest of this thread..)
> > > 
> > > scripts/mod/modpost.c looks for certain variable names to identify
> > > variables that can have references to other (non-data) sections.
> > > It's mostly explained there.
> > 
> > Another option is to annotate the relevant variable.
> 
> Ok, I guess I knew about the annotations. So I take it the name magic
> exists just for convenience or to hit the common cases?

The name magic was introduced first - and by this we covered a
lot of common cases.
But we could not rename everything and thus we invented
the annotation.

The annotation ar preferable to the name magic becuse they
1) follow the usual way to tell that something is special
2) that it documents that this data structure have deliberate
  access to *init/*exit sections

So the preference should be to use annotations over name magic.
[Maybe text from modpost needs an update to reflect this...]

	Sam
