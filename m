Return-Path: <linux-kernel-owner+w=401wt.eu-S1755201AbZBBL0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbZBBL0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 06:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZBBL0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 06:26:42 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:58377 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbZBBL0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 06:26:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Sww9fHhk+b4T1zG7eay1vG4fonmkxJVj27MthB++AV0KRwCRMfsogbk6b64XkY2R0y
         4JrHUlzmbDJLI7DT/s2G8hQ3wuezs5E3+cS+fkwTDHLdza9EnP+1qHHshEYBs1d4809d
         xOtk2LVRAIK+bkUzLO3M/UxVGADSN/P4a7WtA=
Date: Mon, 2 Feb 2009 12:26:31 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
Message-ID: <20090202112629.GA5757@nowhere>
References: <20090127001708.GA4815@nowhere> <20090126163015.7f879b18@infradead.org> <20090131180347.GC5884@nowhere> <20090131101502.7ce8e7af@infradead.org> <20090131182843.GD5884@nowhere> <1233524261.18767.60.camel@pasglop> <20090202022414.GA5006@nowhere> <1233554443.18767.71.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233554443.18767.71.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 02, 2009 at 05:00:43PM +1100, Benjamin Herrenschmidt wrote:
> On Mon, 2009-02-02 at 03:24 +0100, Frederic Weisbecker wrote:
> > On Mon, Feb 02, 2009 at 08:37:41AM +1100, Benjamin Herrenschmidt wrote:
> > > 
> > > > I don't know, most of those I've looked on are not documented about the reason
> > > > for a private workqueue. I guess most of them can use the usual kevent.
> > > 
> > > The main problem with kevent is that it gets clogged up.
> > 
> > 
> > I don't think so. Here is a snapshot of the workqueue tracer in my
> > box currently:
> 
> That's not quite what I meant ... 
> 
> The main problem with keventd I'd say is that it's used in all sort of
> exeptional code path (ie, driver reset path, error handling, etc...) for
> things that will msleep happily for tenth milliseconds, that sort of
> thing.
> IE. It will be pretty responsive -in general- but can suffer form
> horrible latencies every now and then.


So I think it should be reserved for small, quick jobs which don't sleep for
too much time.
I can improve the workqueue tracer to localize these callsites if needed. And
why not warn on such cases if some kind of option is selected.

 
> Cheers,
> Ben.
> 

