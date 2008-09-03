Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbYICO0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbYICO0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 10:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbYICO0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 10:26:41 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:45140 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431AbYICO0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 10:26:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dd4Hgk4wlWe7NG1uBFvNqoRx47Y9vmOUGN7uaqP2ysa7RjX0hZKxUAsl5HtoLzMBlj
         Lf9g9tZ80/z9nuiesGm/mNxYBGiqPhYXaD5SfVC0SbbQO82bwCt/SUl8+c7kMCCtfOTe
         OjdORtyBigDcX/dlbLX8uzcC5oviERScZIotE=
Date: Wed, 3 Sep 2008 10:26:30 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Barkalow <barkalow@iabervon.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       Christopher Desjardins <cddesjardins@gmail.com>
Subject: Re: Lenovo 3000 N100 i8042 problems
Message-ID: <20080903102047.ZZRA012@mailhub.coreip.homeip.net>
References: <alpine.LNX.1.00.0808240148580.19665@iabervon.org> <Pine.LNX.4.64.0809020120130.29111@twin.jikos.cz> <alpine.LNX.1.00.0809012014280.19665@iabervon.org> <alpine.LNX.1.10.0809021121410.23448@jikos.suse.cz> <20080902083940.ZZRA012@mailhub.coreip.homeip.net> <alpine.LNX.1.00.0809021200470.19665@iabervon.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.00.0809021200470.19665@iabervon.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2008 at 12:16:15PM -0400, Daniel Barkalow wrote:
> On Tue, 2 Sep 2008, Dmitry Torokhov wrote:
> 
> > On Tue, Sep 02, 2008 at 11:23:25AM +0200, Jiri Kosina wrote:
> > > 
> > > so the product name both of System and Base Board are different, and 
> > > apparently the systems differ. Dmitry, what fields would you propose to be 
> > > put in the DMI matching here? I will do the patch then.
> > > 
> > 
> > I guess we could use System's product name to differentiate between
> > Cristopher's and Daniel's boards. Although I must admit it is the very
> > first time when I see a box that behaves better with active mux. DOes
> > Vista use active mux nowadays? Because if it is not then I bet there
> > is (or shortly will be) a BIOS update fixing legacy mode on Daniel's
> > box.
> 
> Mine's actually old (came with XP). It's still got the original BIOS 
> (because I haven't found a way to upgrade the BIOS without reformatting my 
> hard drive to include Windows), and I remember there being an upgrade 
> available, but I don't think it had anything to do with keyboard/trackpad 
> stuff.
> 
> In what way does active mux usually behave badly? It's possible that 

It usually manifests with a touchpad/mouse missing because they don't
responf to kernel's queries. Quite a few Fujitsus exibit this
behavior.

> legacy mode only has a bug that doesn't matter to Windows, and active mux 
> may have some of the usual problems but nothing I particularly noticed.
> 
> I noticed that, when my i8042 would stop working, it would generally have 
> just delivered one mouse interrupt to CPU1 after never previously doing 
> so. Perhaps there's some sort of deadlock in the Linux i8042 driver when 
> both cores are unexpectedly getting interrupts from the two devices at 
> once? I could understand there being a Linux bug only triggered by quirky 
> hardware that only applies to legacy mode, which was just uncovered by 
> this patch.
>

I am not sure, internally we the kernel still deals with 2 interrupt
sources (KBD and AUX) regardless whether it is in legacy or active
multiplexing mode...

Does it take long to trigger the bug? You coudl try doing "echo 1 >
/sys/modules/i8042/parameters/debug" and thend me dmesg or
/var/log/messages after the bug was triggered - I might see something
there. But please be aware that if you send me such a log I can decode
everything that you have been typing...

-- 
Dmitry
