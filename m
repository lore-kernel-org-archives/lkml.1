Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbYFJWNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbYFJWNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 18:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbYFJWNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 18:13:05 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:58680
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753891AbYFJWND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 18:13:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtQCAFCZTkh8qNvt/2dsb2JhbAAIkxaeOw
X-IronPort-AV: E=Sophos;i="4.27,619,1204470000"; 
   d="scan'208";a="275700593"
Subject: Re: Is configfs the right solution for configuration based fs?
From: Ben Nizette <bn@niasdigital.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Joel Becker <joel.becker@oracle.com>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>, Felix Fietkau <nbd@openwrt.org>,
       Al Viro <viro@ftp.linux.org.uk>, "H. Peter Anvin" <hpa@kernel.org>
In-Reply-To: <1213084880.22220.29.camel@johannes.berg>
References: <43e72e890806081425h4e785800nc618fc1985f9809f@mail.gmail.com>
	 (sfid-20080608_232543_873639_74C0A387)  <1213002187.698.62.camel@johannes.berg>
	 <1213056772.4089.42.camel@moss.renham>
	 <1213084880.22220.29.camel@johannes.berg>
Content-Type: text/plain
Organization: Nias Digital
Date: Wed, 11 Jun 2008 08:12:58 +1000
Message-Id: <1213135978.3213.51.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-06-10 at 10:01 +0200, Johannes Berg wrote:
> On Tue, 2008-06-10 at 10:12 +1000, Ben Nizette wrote:
> > On Mon, 2008-06-09 at 11:03 +0200, Johannes Berg wrote:
> > 
> > > Personally, I have a few issues with this:
> > >  1) why bother with a second configuration interface that we have to
> > >     maintain, adjust, ...? if we need scriptable access, then make a
> > >     good userspace tool that is scriptable.
> > 
> > What's the first one, sysfs..?  ioctl (eww..)?  
> 
> netlink.

Ah right.  Netlink is indeed a nice interface for this kind of network
device configuration, I'd probably use that for this task too.

Of course, it isn't a general solution to the problem.  If I were
answering the question in $(SUBJECT) I'd say configfs is a good choice.
In the specific case of network devices, you're lucky enough to have
something more specifically tailored to your needs already.

> 
> > >  2) string-based stuff is often messy, especially the varying attributes
> > >     like MAC addresses etc. Unless we just use binary files again, which
> > >     is not very useful again. Take, for example, the monitor flags. If
> > >     we use the same flags then nobody really knows what's up 
> > >     (echo 0x3 > mntr_flags?) and if we use strings then we cannot easily
> > >     ever rename the flag while keeping ABI/API compatibility.
> > 
> > Not sure I see the argument here, why would you want to change the flag
> > name?  If you decide the old name is stupid then can't you just alias
> > the old name to the new one?
> 
> Sure can do, but it just adds a lot of complexity to the kernel. I don't
> see the point, it's not like you need a lot of code to build netlink
> messages. Heck, I've done it by _hand_ and used just netlink sockets.
> It's not a lot of code.
> 
> > String handling is always a bit iffy, though it has to be done
> > somewhere, either in kernel or in your "good userspace tool which is
> > scriptable".  I'd prefer to have it done once, well, in the kernel and
> > not have to ship more software than necessary.
> 
> I personally prefer to put it into userspace.

Yeah, personal preference here.  I come from an embedded background and
have an aversion to tracking more userspace tools than I have to.  This
mainly comes from the fact uClibc (an embedded C library) doesn't
maintain binary compatibility across releases; each time a bugfix comes
out for that my entire userspace needs to be recompiled.  Each userspace
tool I add to my build scripts makes me die a little inside ;-)


	--Ben.


