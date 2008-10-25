Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbYJYQ3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbYJYQ3s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 12:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbYJYQ3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 12:29:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:47527 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbYJYQ3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 12:29:39 -0400
Date: Sat, 25 Oct 2008 09:29:42 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [pull request] getting rid of __cpuinit
Message-ID: <20081025092942.40342ad0@infradead.org>
In-Reply-To: <20081025162116.GA13303@uranus.ravnborg.org>
References: <20081024142056.6a2d082a@infradead.org>
	<20081025075925.GA22805@uranus.ravnborg.org>
	<20081025070043.50578543@infradead.org>
	<20081025143528.GA30900@uranus.ravnborg.org>
	<20081025080638.6203c874@infradead.org>
	<20081025162116.GA13303@uranus.ravnborg.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2008 18:21:16 +0200
Sam Ravnborg <sam@ravnborg.org> wrote:

> On Sat, Oct 25, 2008 at 08:06:38AM -0700, Arjan van de Ven wrote:
> > On Sat, 25 Oct 2008 16:35:28 +0200
> > Sam Ravnborg <sam@ravnborg.org> wrote:
> > > So if you look at the size of the cpuinit/exit sections in the
> > > before case you get the real space saving that is lost in the
> > > embedded case after your patch is applied.
> > > The space savings that happen after early init.
> > 
> > [linux.trees.git]# objdump -h vmlinux.before  | grep init.text
> >  25 .init.text    00037c25  ffffffff8152a000  000000000152a000
> > 0092a000 [inux.trees.git]# objdump -h vmlinux.after  | grep
> > init.text 25 .init.text    000316c2  ffffffff81542000
> > 0000000001542000  00942000
> 
> So with your config we will loose a saving of 25955 bytes
> of text.
> 
> I tried to look a the numbers of a defconfig build here.
> cpuinit.text equals 0x5d97 = 23959
> cpuinit.data equals 0x3574 = 13684
> 
> [objdump of vmlinux.o gives you the size of the cpuinit sections]
> 
> So if we decide to drop cpuinit then it should be based on the
> above figure and not the 2k figure you gave in the original mail.
> 
> Or even better we should see the difference with a typical
> embedded configuration and not some big defconfig build.
> I will assume the saving is less on a typical embedded
> configuration.

it will be; on x86 you end up inheriting all cpu vendors init code.
on embedded you only have  the dedicated CPU code.

... just that on x86... nobody seems to be in this position, it's
almost impossble to have HOTPLUG_CPU even be asked.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
