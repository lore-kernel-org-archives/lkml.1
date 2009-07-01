Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbZGARbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbZGARbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 13:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbZGARa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 13:30:59 -0400
Received: from outbound-mail-06.bluehost.com ([69.89.17.206]:38027 "HELO
	outbound-mail-06.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751158AbZGARa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 13:30:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=I6DgM4Zr/33RsnhKiXJoIfBJFmVRdzjSbJN5fhAcFdQnW32Y24T42acVtdbZxom1Z0vJ1NIIUzHuuyGcadye7L8ZbzuLlbwJlkXMf30UzX6xVBSFAm+YX7I99Z5l65vM;
Date: Wed, 1 Jul 2009 10:30:59 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, Greg KH <gregkh@suse.de>,
       x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Kurt Garloff <garloff@suse.de>,
       linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] x86: sysctl to allow panic on IOCK NMI error
Message-ID: <20090701103059.402e012a@jbarnes-g45>
In-Reply-To: <20090701111003.GC15958@elte.hu>
References: <20090624213211.GA11291@kroah.com>
	<alpine.LFD.2.00.0906302324350.23134@eddie.linux-mips.org>
	<20090630223040.GA3802@suse.de>
	<alpine.LFD.2.00.0907010148490.23134@eddie.linux-mips.org>
	<20090701111003.GC15958@elte.hu>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.17.2; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009 13:10:03 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Maciej W. Rozycki <macro@linux-mips.org> wrote:
> 
> > On Tue, 30 Jun 2009, Greg KH wrote:
> > 
> > > >  These days an IOCK NMI typically happens in response to a PCI 
> > > > SERR -- it may be useful to traverse PCI buses to find the 
> > > > offender and dump this information on this occasion too.  The 
> > > > south bridge may have additional status too.
> > > 
> > > Sure, that would be great to have.  Care to make a patch?  :)
> > 
> >  ENOTIME, sorry.  Next year perhaps.  Or a homework project for 
> > one of the newbies. ;)
> 
> You know that this project would kill a newbie, right? :)
> 
> We have no real southbridge drivers on x86 - but we should certainly 
> add some. Also, walking the PCI device tree from NMI context is 
> tricky as the lists there are not NMI safe - we could crash if we 
> happen to get a #IOCK while loading/unloading drivers (which is rare 
> but could happen).
> 
> IMHO it's all very much desired functionality, but highly 
> non-trivial.

We actually have some code to do this for PCIe AER support.  If we
detect multiple errors or the root complex doesn't give us error ID
info, we walk the bus looking for errors.  So there's some potential
for reuse here...

-- 
Jesse Barnes, Intel Open Source Technology Center
