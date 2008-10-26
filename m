Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbYJZMGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbYJZMGX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 08:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYJZMGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 08:06:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:35483 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751742AbYJZMGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 08:06:14 -0400
X-Authenticated: #1142740
X-Provags-ID: V01U2FsdGVkX1/wfZZXoz3w/U62X3mPlKgFKuRcZa8EPIlvTKUPet
	cH0Q7IWxov6ss3
From: Hartmut Niemann <Hartmut.Niemann@gmx.de>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: nfsroot.txt in 2.4.36.7 and 2.6.27.1, Configure.help in 2.4.36.7: missing precondition CONFIG_IP_PNP
Date: Sun, 26 Oct 2008 13:06:14 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200810252347.01484.Hartmut.Niemann@gmx.de> <20081026032711.GV24654@1wt.eu>
In-Reply-To: <20081026032711.GV24654@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810261306.14142.Hartmut.Niemann@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 26. Oktober 2008 04:27 schrieb Willy Tarreau:
> > In kernel versions 2.4.36.7 and 2.6.27.1 (I checked only these) the file
> > nfsroot.txt fail to mention, that
> > Kernel level autoconfiguration CONFIG_IP_PNP *must* be selected
> > (in 2.6.27.1 the wording is much better mentioning that nfs may not be
> > compiled as a module than in 2.4.36.7)
> > in order to be able to even *see* the option
> > "Root file system on NFS" (CONFIG_ROOT_NFS)
> > -- except for xconfig in 2.4.36, which allowed me to see that there is
> > this option (greyed), and to see it's help text. (This, by the way,
> > was a big help -- I could see that the option is still present in current
> > kernels)
>
> Kbuild in 2.6 is much more evolved than in 2.4 as it knows about
> dependencies, and tells the user what needs to be enabled for each
> option. It's true that xconfig is sometimes helpful on 2.4 for this
> reason, but I tend to grep for the option rather than starting xconfig.
I grepped in Configure.help too. That was when I noticed that the 
CONFIG_ROOT_NFS help text
didn't help. I found the explanation in CONFIG_NFS_FS when I 
started to edit Configure.help...

Maybe we should change the CONFIG_ROOT_NFS help section to
"please read the CONFIG_NFS_FS help".

By the way: 2.6 kbuild won't tell you anything about how to activate 
CONFIG_ROOT_NFS unless the dependencies are met i.e. 
CONFIG_IP_PNP is set, so while it 
lists the dependencies, it does that only for those options that it will
allow to be set. Otherwise you won't even see that there is an 
option "CONFIG_ROOT_NFS" and won't be able to select it's help text to be 
displayed. That makes the dependencies in the helptext less valuable.
I checked that for menuconfig and xconfig.
>
> > I reordered the section 1 of nfsroot.txt (of 2.6.27.1), diff is attached.
> > (And I fixed some chapter numbering in section 3).
> > Is this document otherwise correct for 2.4 and can be updated there too?
> > The version in 2.4.36.7 is
> >
> > The help text of CONFIG_ROOT_NFS in 2.4.36.7 is quite funny:
> >   "It is
> >   likely that in this case, you also want to say Y to "Kernel level IP
> >   autoconfiguration" so that your box can discover its network address
> >   at boot time."
> > Does that make clear that you can not even see this option
> > during make *config unless you set "Kernel level IP autoconfiguration"?
> > The help text of CONFIG_NFS_FS does contain the information,
> > but I found it there a little late. The texts in 2.6 are better.
> >
> > A diff for 2.4.36.7 Configure.help is attached as well.
> >
> > Is this correct?
>
> Your explanation seems correct, but it only explains better the option
> which you couldn't find. So you still have to enable it first in order
> to find how to enable it :-/  I've just checked the help for CONFIG_NFS_FS,
> and it is quite clear about the fact that you need to enable IP autoconfig
> to enable NFS ROOT. Maybe it is this section which should be enhanced to
> tell where to enable those options ?

No. Once you find out that the CONFIG_NFS_FS help is all you need, you 
succeded.
But if you read nfsroot.txt or anything in the web, it will tell you to enable 
CONFIG_ROOT_NFS, not to read CONFIG_NFS_FS help.
(Maybe my posting will help somebody someday only for the reason that 
it is indexed, found and displayed by $search_engine :-)

Hartmut
