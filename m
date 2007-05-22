Return-Path: <linux-kernel-owner+w=401wt.eu-S1764164AbXEVVkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764164AbXEVVkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 17:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757137AbXEVVkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 17:40:33 -0400
Received: from mail.gmx.net ([213.165.64.20]:44969 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756427AbXEVVkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 17:40:32 -0400
X-Authenticated: #8359428
X-Provags-ID: V01U2FsdGVkX19+GQpFUOl+mcuh93YdVGZ03Nyfztc8Pmy8MCx4/Q
	+act5eNJRLDKqG
From: Uwe Bugla <uwe.bugla@gmx.de>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
Date: Tue, 22 May 2007 23:35:25 +0200
User-Agent: KMail/1.9.5
References: <464F42F3.1080300@madrabbit.org> <20070520062816.GA4095@ftp.linux.org.uk> <Pine.LNX.4.61.0705222217300.4452@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705222217300.4452@yvahk01.tjqt.qr>
Cc: Al Viro <viro@ftp.linux.org.uk>, Ray Lee <ray-lk@madrabbit.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>, Ken Chen <kenchen@google.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       "Torvalds, Linus" <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705222335.25758.uwe.bugla@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 22. Mai 2007 22:18 schrieben Sie:
> On May 20 2007 07:28, Al Viro wrote:
> >On Sat, May 19, 2007 at 11:16:59PM -0700, Ray Lee wrote:
> >> Ken? Ball's in your court. As the patch isn't providing a killer
> >> feature for 2.6.22, I'd suggest just reverting it for now until the
> >> issues are ironed out.
> >
> >Hold it.  The real question here is which logics do we want there.
> >IOW, and how many device nodes do we want to appear and _when_ do
> >we want them to appear?
>
> "min_loop" (max_loop?) nodes should appear (but without a backing
> gendisk), and when they are opened, they should get their gendisk
> allocated and assigned.
>
>
>
> 	Jan

Jan,

Please stick to the latest revised patch residing in Andrew's mm-tree now.

All that I wanted was a possibility to mount up to eight 8 iso images to be 
mounted parallely at boot time using udev and AVOID fuzzing around with 
additional nodes in /dev/loop.

This desire isn't nonsense at all:

For instance, if you run Debian "Lenny" testing, you need to mount 4 DVD iso 
images parallely at boot time (at least I do need that) if you do not want to 
waste time with opening and closing your DVD device at all.

Then there may be other desires:
a. For instance mounting Christian Marillat's unofficial Debian iso image at 
boot time (multimedia stuff).
b. For instance to mount and run all sampled libraries for helping the wine 
package to be as compatible as possible (i. e. winetools by Joachim von 
Thadden)

and so on.....

That means: At least for my personal desire, Ken Chen's latest patch was OK so 
far.

Now, if there is a specific need for mounting up to 256 iso images including 
whatever technical basis or userspace tools requiries or changings of 
whatever kind then at least I do not care about the what and why at all.

But the facts for now at least go like this:

1. Ken Chen's latest patch, criticised and enhanced by Andrew Morton, acked by 
Al Viro, is now part of the latest mm-tree.

2. The three patches leading to the disaster of breaking userspace are not yet 
ripped out of Linus's 2.6.22-rc2-tree.

In so far I would deeply appreciate Linus Torvalds to rip put the mentioned 
patches mentioned, just to avoid future troubles.

Yours sincerely

Uwe

P. S.:
1. The first approach, a common work by Ken Chen and Al Viro, was an approach 
promising up to 256 iso images to be mounted dynamically on user's demand 
while really offering only one iso image to be mounted and, after the desire 
to mount some more at boot time, stop working.

I would evaluate that approach as stuff for cabaret laughter, jokin', or 
simply a terrible bug.

2. I do not like / appreciate discussions on items that seem to be far away 
from actual user's needs, without being proven by examples of real necessity.

Otherwise expressed: Who really needs actually to mount up to 256 iso images 
using the loop device? I am ready to learn...... :)

3. I have seen this feature of "virtual DVD devices" under Windoze XP, 
established for whatever nonsense reason. Question: Who actually needs to 
mount parallely for instance up to 200 video DVDs wasting Ram like hell?

I would call that a kind of fetish, i. e. I do not see the deeper sense of it!

The base line for linux as an operating system is: "Small and effective is 
Beautiful", isn't it?
