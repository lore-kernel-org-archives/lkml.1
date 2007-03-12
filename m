Return-Path: <linux-kernel-owner+w=401wt.eu-S1752843AbXCLUCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbXCLUCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 16:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbXCLUCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 16:02:18 -0400
Received: from lilly.ping.de ([83.97.42.2]:4909 "HELO lilly.ping.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752843AbXCLUCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 16:02:17 -0400
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Mar 2007 16:02:16 EDT
Date: Mon, 12 Mar 2007 20:54:36 +0100
From: Patrick Mau <mau@oscar.ping.de>
To: Douglas McNaught <doug@mcnaught.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: RSDL for 2.6.21-rc3- 0.29
Message-ID: <20070312195436.GA15319@oscar.prima.de>
References: <20070311013506.GD10459@waste.org> <200703121428.29947.gene.heskett@gmail.com> <87wt1mjo4q.fsf@suzuka.mcnaught.org> <200703121510.18268.gene.heskett@gmail.com> <87slcajliq.fsf@suzuka.mcnaught.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87slcajliq.fsf@suzuka.mcnaught.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 03:43:09PM -0400, Douglas McNaught wrote:
> Gene Heskett <gene.heskett@gmail.com> writes:
> 
> > On Monday 12 March 2007, Douglas McNaught wrote:
> >>Gene Heskett <gene.heskett@gmail.com> writes:
> >>> I'd considered it, but with 32 dle entries, the whole strace output
> >>> would be terrabytes & I don't have THAT much disk.  Not to mention it
> >>> traces only the parent process, so tar would be merrily marching along
> >>> to its own drummer and not traced I'm  afraid.
> >>
> >>$ strace -ff
> >>
> >>-Doug
> >
> > Someone else suggested the single -f, and I tried that, but even with the 
> > shell history set for 100,000 lines, i can't get back to the start, and I 
> > think its mucking with the shell arguments numbering as what I can see is 
> > about 5 reads through /etc/services accompanied by endless complaints 
> > of -EBADFD, the the logfile it generates says the port it was given was 
> > rejected when amcheck was run, here is that snip:
> 
> I'd do 'strace -ff -o /tmp/amanda-strace <command>', which will give
> you a set of files in /tmp, one for each PID created by fork().  Then
> find the one that has the 'tar' invocation you're looking for.

Hi,

I hope you don't mind me jumping in ...

Why not temporarly replace "/bin/tar" with a shell script that does:

#!/bin/sh
exec strace -f -o output /bin/real.tar $@

That should be working, shouldn't it ?

Cheers,
Patrick

