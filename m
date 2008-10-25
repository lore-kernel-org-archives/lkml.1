Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbYJYSPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbYJYSPq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 14:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbYJYSPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 14:15:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51218 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbYJYSPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 14:15:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [pull request] getting rid of __cpuinit
Date: Sat, 25 Oct 2008 20:20:00 +0200
User-Agent: KMail/1.9.9
Cc: Sam Ravnborg <sam@ravnborg.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>
References: <20081024142056.6a2d082a@infradead.org> <20081025162116.GA13303@uranus.ravnborg.org> <20081025092942.40342ad0@infradead.org>
In-Reply-To: <20081025092942.40342ad0@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810252020.01352.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 25 of October 2008, Arjan van de Ven wrote:
> On Sat, 25 Oct 2008 18:21:16 +0200
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > On Sat, Oct 25, 2008 at 08:06:38AM -0700, Arjan van de Ven wrote:
> > > On Sat, 25 Oct 2008 16:35:28 +0200
> > > Sam Ravnborg <sam@ravnborg.org> wrote:
> > > > So if you look at the size of the cpuinit/exit sections in the
> > > > before case you get the real space saving that is lost in the
> > > > embedded case after your patch is applied.
> > > > The space savings that happen after early init.
> > > 
> > > [linux.trees.git]# objdump -h vmlinux.before  | grep init.text
> > >  25 .init.text    00037c25  ffffffff8152a000  000000000152a000
> > > 0092a000 [inux.trees.git]# objdump -h vmlinux.after  | grep
> > > init.text 25 .init.text    000316c2  ffffffff81542000
> > > 0000000001542000  00942000
> > 
> > So with your config we will loose a saving of 25955 bytes
> > of text.
> > 
> > I tried to look a the numbers of a defconfig build here.
> > cpuinit.text equals 0x5d97 = 23959
> > cpuinit.data equals 0x3574 = 13684
> > 
> > [objdump of vmlinux.o gives you the size of the cpuinit sections]
> > 
> > So if we decide to drop cpuinit then it should be based on the
> > above figure and not the 2k figure you gave in the original mail.
> > 
> > Or even better we should see the difference with a typical
> > embedded configuration and not some big defconfig build.
> > I will assume the saving is less on a typical embedded
> > configuration.
> 
> it will be; on x86 you end up inheriting all cpu vendors init code.
> on embedded you only have  the dedicated CPU code.
> 
> ... just that on x86... nobody seems to be in this position, it's
> almost impossble to have HOTPLUG_CPU even be asked.

FWIW, I like the idea of removing __cpuinit.  It often is quite difficult to
determine if given piece of code should be marked as __cpuinit and that leads
to bugs that are not so easy to resolve.

Thanks,
Rafael
 
