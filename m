Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbZFAT0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbZFAT0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 15:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbZFAT0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 15:26:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35812 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbZFAT0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 15:26:23 -0400
Date: Mon, 1 Jun 2009 15:26:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Christian =?iso-8859-1?Q?Borntr=E4ger?= <borntraeger@de.ibm.com>,
       Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: add localversion to avoid confusion and conflicts
Message-ID: <20090601192624.GA32428@goodmis.org>
References: <1243581494.3212.1.camel@localhost.localdomain> <200905290948.34482.borntraeger@de.ibm.com> <1243586626.4379.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1243586626.4379.15.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 02:13:46PM +0530, Jaswinder Singh Rajput wrote:
> On Fri, 2009-05-29 at 09:48 +0200, Christian Bornträger wrote:
> > Am Freitag 29 Mai 2009 09:18:14 schrieb Jaswinder Singh Rajput:
> > > Adding localversion avoids confusion in kernel images :
> > >
> > > like Linux version 2.6.30-rc7 does not tell whether it is linus or kvm
> > > kernel.
> > >
> > > By adding localversion it tells :
> > >
> > > Linux version 2.6.30-rc7-kvm , any doubt ;-)
> > > I am inspired by Ingo's -tip, I am sure Ingo will tell more advantages,
> > > if these are not enough :-)
> > [...]
> > > diff --git a/localversion-kvm b/localversion-kvm
> > > new file mode 100644
> > > index 0000000..d969ff0
> > > --- /dev/null
> > > +++ b/localversion-kvm
> > > @@ -0,0 +1 @@
> > > +-kvm
> > 
> > NAK from my side. If you need a distinction, there is always 
> > CONFIG_LOCALVERSION_AUTO. If you need this kind of prefix, there is always  
> > CONFIG_LOCALVERSION.
> > 
> 
> Here is NAK for your NAK from my side.

And here is a NACK for your NACK of a NACK!

> 
> This patch is only for KVM tree and not for linus tree.
> 
> Lets assume 100 developers are working on kvm tree and they use kvm tree
> on 2 PCs. So count becomes 200.
> 
> Like in my case I have dozen of kernel trees so I keep on swapping
> config between kernels. And I also need to test config from various
> users. So this count is countless.
> I think this is the biggest point for adding localversion in -tip.
> It seems Ingo is busy in perfcounter stuff otherwise he will explain you
> more advantages.
> 
> In the least case, Can you differentiate between 1 and 200 ?
> 
> So by adding this patch we can save lot of developer's time.

No this patch wastes a lot of developers time. If we accept it, than any
patch that is added after it will need to be rebased before going to
Linus. Unless KVM is made up of a bunch of branches like tip is, this will become
more of a hassle than a benefit.

Ingo's tip/master is based off of a bunch of branches. It is not recommended to
develope against tip/master. I develop against tip/tracing/core, because that is
what will get pulled by Linus. tip/master is created automatically from a bunch of
branches and gets rebased all the time. One of those branches is tip, which supplies
the localversion. Thus, if you use tip/master, you get the localversion file. But
if you develop against one of the main branches that will eventually go to Linus,
then you will not have that localversion file.

-- Steve

