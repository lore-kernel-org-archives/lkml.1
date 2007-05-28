Return-Path: <linux-kernel-owner+w=401wt.eu-S1757890AbXE1E2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890AbXE1E2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 00:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbXE1E2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 00:28:40 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:48628 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbXE1E2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 00:28:39 -0400
Date: Mon, 28 May 2007 09:57:48 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Chris Newport <crn@netunix.com>,
       Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       linux-pcmcia@lists.infradead.org,
       Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>,
       Tejun Heo <htejun@gmail.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Kristian H?gsberg <krh@bitplanet.net>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Marcus Better <marcus@better.se>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2/3] 2.6.22-rc2: known regressions v2
Message-ID: <20070528042747.GB6367@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <alpine.LFD.0.98.0705241007290.26602@woody.linux-foundation.org> <20070524193740.GA6787@elte.hu> <alpine.LFD.0.98.0705241247540.26602@woody.linux-foundation.org> <20070525101105.GA9268@elte.hu> <4656CE39.8050800@netunix.com> <alpine.LFD.0.98.0705250937550.26602@woody.linux-foundation.org> <20070525180304.2cc4dae0@the-village.bc.nu> <alpine.LFD.0.98.0705251012200.26602@woody.linux-foundation.org> <20070525103714.092ad631.akpm@linux-foundation.org> <alpine.LFD.0.98.0705251039300.26602@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705251039300.26602@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 10:50:38AM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 25 May 2007, Andrew Morton wrote:
> >
> > > > There is an additional factor - dumps contain data which variously is -
> > > > copyright third parties, protected by privacy laws, just personally
> > > > private, security sensitive (eg browser history) and so on.
> > > 
> > > Yes. 
> > 
> > We're uninterested in pagecache and user memory and they should be omitted
> > from the image (making it enormously smaller too).
> 
> The people who would use crash-dumps (big sensitive firms) don't trust 
> you.
> 
> And they'd be right not to trust you. You end up having a _lot_ of 
> sensitive data even if you avoid user memory and page cache. The network 
> buffers, the dentries, and just stale data that hasn't been overwritten.
> 
> So if you end up having secure data on that machine, you should *never* 
> send a dump to somebody you don't trust. For the financial companies 
> (which are practically the only ones that would use dumps) there can even 
> be legal reasons why they cannot do that!
> 
> > That leaves security keys and perhaps filenames, and these could probably
> > be addressed.
> 
> It leaves almost every single kernel allocation, and no, it cannot be 
> addressed.
> 
> How are you going to clear out the network packets that you have in 
> memory? They're just kmalloc'ed. 
> 
> > > I'm sure we've had one or two crashdumps over the years that have actually 
> > > clarified a bug.
> > > 
> > > But I seriously doubt it is more than a handful. 
> > 
> > We've had a few more than that, but all the ones I recall actually came
> > from the kdump developers who were hitting other bugs and who just happened
> > to know how to drive the thing.
> 
> Right, I don't dispute that some _developers_ might use dumping. I dispute 
> that any user would practically ever use it.
> 
> And even for developers, I suspect it's _so_ far down the list of things 
> you do, that it's practically zero.
> 
> > > But 99% of the time, the problem doesn't happen on a developer machine, 
> > > and even if it does, 90% of the time you really just want the traceback 
> > > and register info that you get out of an oops.
> > 
> > Often we don't even get that: "I was in X and it didn't hit the logs".
> 
> Yes. 
> 

Isn't it reason enough for customers to use it? How will a customer 
capture even an OOPS meesage? Lets say some web server crashed and OOPs 
message did not make it to logs. I am not expecting a customer to setup
a console for each and every machine in the network. In this scenario
customer will have no choice but to reset the machine without any
information about why did machine crash.

If one can keep kdump configured, upon a crash there are high chances
that customer will have some debug information to look at. I agree that
security of data can be a concern. In that case probably one can extract
a small dump report, like OOPs message, messages in the kernel buffers
just before crash etc. and report it to service folks. 

Without kdump, customer will most likely have no debug data except a
complain that system crashed and rebooted or it had to be reset by manual
intervention.

Thanks
Vivek
