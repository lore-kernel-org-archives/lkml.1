Return-Path: <linux-kernel-owner+w=401wt.eu-S1761437AbZE1Np7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761437AbZE1Np7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 09:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762732AbZE1Npw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 09:45:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61430 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763217AbZE1Npv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 09:45:51 -0400
Date: Thu, 28 May 2009 09:45:51 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Greg KH <greg@kroah.com>
cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       GeunSik Lim <leemgs1@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org,
       balagi@justmail.de, bgamari@gmail.com, Ingo Molnar <mingo@elte.hu>,
       inaky.perez-gonzalez@intel.com
Subject: Re: [RFC PATCH]debugfs:Fix terminology inconsistency of dir name to
 mount debugfs filesystem.
In-Reply-To: <20090527191310.GA466@kroah.com>
Message-ID: <alpine.DEB.2.00.0905280929190.27708@gandalf.stny.rr.com>
References: <1243315163.14685.17.camel@centos51> <alpine.DEB.2.00.0905261642130.26705@gandalf.stny.rr.com> <20090526205414.GA26016@kroah.com> <alpine.DEB.2.00.0905261711310.26705@gandalf.stny.rr.com> <49b7c2350905261924h34e5f019g9e38735bb64bbf87@mail.gmail.com>
 <alpine.DEB.2.00.0905262231210.27902@gandalf.stny.rr.com> <1243403437.3118.10.camel@localhost.localdomain> <alpine.DEB.2.00.0905271418290.17378@gandalf.stny.rr.com> <20090527191310.GA466@kroah.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 27 May 2009, Greg KH wrote:
> > > > 
> > > > ( Note: it is more common to mount at /sys/kernel/debug, but for
> > > >   simplicity this document will use /debug)
> > > > ===

> > 
> > I really don't want to do that. Then I would need to show
> > 
> >  # echo function_graph > /sys/kernel/debug/current_trace
> > 
> > Which I really do not like. I state that the common place to mount it is 
> > in /sys/kernel/debug, But my examples are much easier to understand if
> > I just do: # echo function_graph > /debug/current_trace
> 
> It's not just the "common" place, it is the DOCUMENTED PLACE.

I can change the wording to be "documented" or "distro mounted".

> 
> I'm sorry you have to type a long path, perhaps you wish to invest in a
> tab key for auto-completion :)
> 
> Again, distros already mount debugfs at this location, please don't
> confuse people just because you are annoyed at the length of the path.

Have you found which packages do that?

The point is that the document is more interested in showing the files 
that are being used, and if I add /sys/kernel/debug/ in front of every 
file, that just distracts from the eye. As stated:

  "but for simplicity this document will use /debug"

I'll update ftrace.txt to explain it better.

Something like:

=====
Debugfs is mounted by some packages at /sys/kernel/debugfs. If it is not 
you can mount it by adding

 debugfs   /sys/kernel/debug  debugfs   defaults   0   0

to your /etc/fstab, or by manually mounting it:

 # mount -t debugfs nodev /sys/kernel/debugfs

For simplicity, this document will assume that you also added the 
following symbolic link:

 # ln -s /sys/kernel/debugfs /debug
=====

Then I can keep the document simplistic and still have the "DOCUMENTED" 
locating specified.

-- Steve

