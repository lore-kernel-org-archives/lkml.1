Return-Path: <linux-kernel-owner+w=401wt.eu-S1757835AbZFKWAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835AbZFKWAB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 18:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbZFKV7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 17:59:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35129 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744AbZFKV7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 17:59:43 -0400
Date: Thu, 11 Jun 2009 17:59:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@google.com>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Al Viro <viro@zeniv.linux.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
Message-ID: <20090611215941.GA14053@goodmis.org>
References: <20090611165226.GV8633@ZenIV.linux.org.uk> <1244739378.6691.540.camel@laptop> <20090611170015.GA3651@infradead.org> <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain> <33307c790906111124m17e57332oc38c89fa70e39231@mail.gmail.com> <alpine.LFD.2.01.0906111127520.3573@localhost.localdomain> <20090611202341.GA23590@elte.hu> <1244753357.27363.82.camel@violet> <20090611210810.GA9317@uranus.ravnborg.org> <1244755036.27363.93.camel@violet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244755036.27363.93.camel@violet>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 11:17:16PM +0200, Marcel Holtmann wrote:
> Hi Sam,
> 
> > > So you are saying that only good code comes from including it into
> > > linux-2.6.git and otherwise you will never get there. Have you actually
> > > tried to maintain this in a separate repository on kernel.org?
> > 
> > Could you please remind us what the arguments agains including a few
> > seleted tools within the kernel source tree was.
> > 
> > I ask because I really cannot see why so much nosie is generated?
> > As a naive user that like easy access to the stuff I work with
> > this looks like an optimal place to find the kernel-hacking
> > tools I need. Why should I hunt somewhere else to find it?
> 
> I personally would expect a perf.git on kernel.org for the userspace
> tools for it. Like we have udev.git there, iproute2.git and others.
> 
> Seems to be working perfectly fine (except of course oprofile) and makes
> packaging and security updates a lot easier. The distros have always a
> really hard problem with releasing new kernel packages. And as long as
> the source changes the whole set of binary packages needs to be rebuilt
> and in theory if you install a new kernel, you should reboot. So if
> there is an issue in perf userspace, then the current processes in most
> distros will propose the user a reboot for no good reason.
> 
> There is nothing wrong with trying something new, but to be honest I
> don't buy into the arguments why we do it. It seems like it is all based
> on bad experience with some userspace maintainers and not really
> technical grounds why it is a must to have this inside the kernel source
> code. Of course you can make the argument the other way around and say
> why not. And I give Linus that he wants to try. However all the
> arguments from Ingo are a joke and basically tells that all userspace
> developers have no clue and can't get right anyway.

Here's another point that I have not really seen anyone make. The tools that
would be packaged with the kernel are the ones that I would expect the average
kernel developer to use. Things to help us in developing better code.

The tools you mentioned

  "ip, iw, rfkill, crda, the WiMAX"

I have no idea what they do. I don't think I would use them as I don't
work on bluetooth, and I don't see how they would help me with what I do
work on.

I use 'udev' only to boot my machine, and I only notice it when it doesn't
work.

As for something like perf, that is something I can see myself using to
analyze my own code. And I can see other developers (even you) using it for
the same purpose. This is a tool that I would like to have the latest version
for the latest version of the kernel I am developing on. That is, if the
latest kernel had a new feature that perf can take advantage of, it would be
nice to have it with the new kernel I just pulled.

This could also work with a perf.git, but I would probably not bother with
it if I had to keep checking the perf.git repo to see if it uses the
new features that are in the kernel. I constantly do 'git pull' for the
kernel and I would get the latest perf with the latest kernel and I 
would not need to bother checking someplace else.

Actually, I can also see that if a new feature in the kernel was added that
perf uses, I would probably notice it first with compiling perf and doing
a perf --help.

> 
> Maybe it is just a sneaky attempt to get a higher hit in Greg's
> statistics by just writing some userspace code which otherwise would not
> be counted ;)

No, that would be something that I do ;-)

/me plans on sending patches for perf.

-- Steve

