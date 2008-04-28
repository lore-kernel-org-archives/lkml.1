Return-Path: <linux-kernel-owner+w=401wt.eu-S934632AbYD1Of0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934632AbYD1Of0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 10:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932574AbYD1OfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 10:35:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:52242 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763242AbYD1OfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:35:10 -0400
Message-ID: <430c4fa50804280735o3d1c3b9cg687f7d374dafbdec@mail.gmail.com>
Date: Mon, 28 Apr 2008 11:35:08 -0300
From: "Sergio Luis" <sergio@larces.uece.br>
To: "Glauber Costa" <gcosta@redhat.com>
Subject: Re: 2.6.25 slow boot/reboot
Cc: "Ken Moffat" <zarniwhoop@ntlworld.com>,
       "Bart Van Assche" <bart.vanassche@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <4815DCEF.3000602@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48141111.7010605@larces.uece.br>
	 <e2e108260804270823t45611ec2t35da085833d82dfa@mail.gmail.com>
	 <20080427235554.GA28344@deepthought> <48152747.4030107@larces.uece.br>
	 <4815DCEF.3000602@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 11:19 AM, Glauber Costa <gcosta@redhat.com> wrote:
>
> Sergio Luis wrote:
>
> > Ken Moffat wrote:
> >
> > > On Sun, Apr 27, 2008 at 05:23:57PM +0200, Bart Van Assche wrote:
> > >
> > > > On Sun, Apr 27, 2008 at 7:37 AM, Sergio Luis <sergio@larces.uece.br>
> wrote:
> > > >
> > > > >  This weekend I got some time and decided to try out 2.6.25, but its
> booting process was _really_ slow in my laptop[1]. With 'old' 2.6.24.5 my
> machine would take about 48 secs until it gave me the login prompt. And it
> would take about 22 seconds to reboot.
> > > > >
> > > > Do you use LILO or GRUB for booting ? 2.6.25 works OK on the systems I
> > > > tested, but LILO really needs a lot of time to load the 2.6.25 kernel.
> > > > GRUB loads the 2.6.25 kernel at normal speed.
> > > >
> > > > Bart.
> > > >
> > >  ISTR that an _old_ version of lilo was mentioned earlier in this
> > > thread.  As a datapoint, on my one desktop box which uses lilo (an
> > > athlon64 uniprocessor) both 32 and 64-bit 2.6.25 kernels boot fine.
> > > Both of those systems are with lilo-22.8, and gcc-4.2.2.
> > >
> > >  But, I think you (Bart) haven't said which version of lilo you are
> > > using ?  If it isn't recent, perhaps upgrading it might help ?
> > >
> > >  For Sergio, you have my sympathy.  I totally failed to bisect my own
> > > problem with 2.6.25-rc (and 2.6.24.1), although I did find the problem
> > > by other means, and got a work-around, so I'm not competent to
> > > diagnose what is wrong, but maybe I can help to tease out what is
> > > different about your box.  As a start, you could try diffing your
> > > config's for 2.6.24.5 and 2.6.25 in case something odd has changed.
> > >
> > >
> >
> > I tried bisecting and after some hours I got
> 9713277607f9eac7d655c6854dd92bc2ce1b6f02 as first bad commit
> >
> > commit 9713277607f9eac7d655c6854dd92bc2ce1b6f02
> > Author: Glauber de Oliveira Costa <gcosta@redhat.com>
> > Date:   Wed Mar 19 14:25:43 2008 -0300
> >
> >    x86: boot cpus from cpu_up, instead of prepare_cpus
> >
> >    After all the infrastructure work, we're now prepared
> >    to boot the cpus from cpu_up, and not from prepare_cpus.
> >    So the difference between cold boot and hotplug is effectively
> >    over, and the functions are used to the purposes they're meant to.
> >
> >    Signed-off-by: Glauber Costa <gcosta@redhat.com>
> >    Signed-off-by: Ingo Molnar <mingo@elte.hu>
> >
> > (cc'ing Glauber and Ingo, maybe they can help)
> >
> >
> > >  Or, perhaps this is a problem specific to a certain processor ?  So
> > > far, I think all the list knows is that you have a problem, and an
> > > old version of lilo.  More data might eventually help to identify
> > > what is causing this.  If you have a fairly old version of lilo,
> > > maybe you also have an old version of gcc ?
> > >
> >
> > lilo version is 22.8
> > gcc version is 4.1.2
> > the processor is an amd turion 64x2 2.0 ghz (tl-60) and I am building a
> 32bit kernel.
> > please, let me know if more info is needed.
> >
> >
> > >  For Bart too, which version(s) of gcc are you using on the systems
> > > where lilo is slow to load, and which cpu(s) do you have there ?
> > >
> > > Ken, who relies on lilo for his server, and gets worried by reports
> > > of trouble with it.
> > >
> >
> > note lilo is indeed much slower than grub to start booting the kernel
> here, but I am talking about this 2.6.25 kernel taking almost 5 min to
> finish the boot process (once it is
> > actually started by the bootloader) when it would take less than 1 minute
> with 2.6.24.5 in
> > this same machine.
> >
> > thanks,
> >
>  Can you give me more information on that?
>  your .config and cpuinfo would be a great start.
>
>  I'm specially interested in things involving APIC.
>

Hello,
I sent the config's (2.6.24.5 and 2.6.25) attached in the first
message of this thread http://lkml.org/lkml/2008/4/27/19
about the cpuinfo, I don't have that computer here right now, as I am
at work, so I can't send it at the moment. It's a TL-60
AMD Turion 64x2 (2.0 GHZ), though, if it helps, and as I said, I am
building a 32 bit kernel with gcc 4.1.2.
Let me know if you need additional info and I will be sending later on
when I am with that laptop again.
thanks,
-sergio
