Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbYICWES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbYICWES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 18:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbYICWED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 18:04:03 -0400
Received: from iabervon.org ([66.92.72.58]:40726 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbYICWEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 18:04:01 -0400
Date: Wed, 3 Sep 2008 18:03:59 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org,
       Christopher Desjardins <cddesjardins@gmail.com>
Subject: Re: Lenovo 3000 N100 i8042 problems
In-Reply-To: <20080903213258.GC14620@khazad-dum.debian.net>
Message-ID: <alpine.LNX.1.00.0809031739350.19665@iabervon.org>
References: <alpine.LNX.1.00.0808240148580.19665@iabervon.org> <Pine.LNX.4.64.0809020120130.29111@twin.jikos.cz> <alpine.LNX.1.00.0809012014280.19665@iabervon.org> <alpine.LNX.1.10.0809021121410.23448@jikos.suse.cz> <20080902083940.ZZRA012@mailhub.coreip.homeip.net>
 <alpine.LNX.1.10.0809031349081.23448@jikos.suse.cz> <20080903101947.ZZRA012@mailhub.coreip.homeip.net> <20080903213258.GC14620@khazad-dum.debian.net>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008, Henrique de Moraes Holschuh wrote:

> On Wed, 03 Sep 2008, Dmitry Torokhov wrote:
> > On Wed, Sep 03, 2008 at 01:50:35PM +0200, Jiri Kosina wrote:
> > > On Tue, 2 Sep 2008, Dmitry Torokhov wrote:
> > > > I guess we could use System's product name to differentiate between 
> > > > Cristopher's and Daniel's boards. Although I must admit it is the very 
> > > > first time when I see a box that behaves better with active mux. DOes 
> > > > Vista use active mux nowadays? Because if it is not then I bet there is 
> > > > (or shortly will be) a BIOS update fixing legacy mode on Daniel's box.
> > > 
> > > I guess so, yes.
> > > 
> > > On the other hand, this might also be viewed as regression (we made 
> > > Daniel's hardware behave worse with recent kernel than it did before), so 
> > > I think we still would like to have this fixed. What about the patch 
> > > below, adding the match on System's product name, as you suggested? 
> > > Thanks.
> > > 
> > 
> > I agree. Daniel, could you please try the patch to make sure it
> > restores the previous behavior for you and I will push it through.
> 
> I fell I need to warn you guys that you are likely breaking machines that
> match that DMI info but have a newer BIOS, unless they use different BIOSes
> (not enough data without a full dmidecode output from the other machine).

The patch under consideration is to restore pre-2.6.25 behavior (i.e., 
active mux) for machines other than the one in a particular bug report, 
while 2.6.25 broke my machine. So this will probably rebreak machines that 
were broken until 2.6.25 (and can't break anything else). I think it would 
actually be better if we could apply the quirk to all models of 3000 N100 
except for mine (but I don't think quirk-matching supports that); my 
model is the only one we know of which came with a BIOS that has issues 
with legacy mode. I still think it's weird that Lenovo managed to break 
active mux when they'd had it working before, but who knows what's going 
on in their firmware development process.

In any case, I suspect that the legacy behavior on my machine is strange 
but manageable (given that Windows doesn't seem to have had problems using 
legacy mode even on my hardware, so far as I can tell), and we should be 
able to cope with it in general.

	-Daniel
*This .sig left intentionally blank*
