Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbYLJAPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbYLJAPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 19:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbYLJAPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 19:15:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751546AbYLJAPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 19:15:20 -0500
Date: Tue, 9 Dec 2008 16:15:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, adobriyan@gmail.com, greg@kroah.com
Subject: Re: linux-next: Tree for December 9
Message-Id: <20081209161511.15fe8cdb.akpm@linux-foundation.org>
In-Reply-To: <ac3eb2510812091606k5615135fn87d35aaa16834ea8@mail.gmail.com>
References: <20081209185237.8bb715d7.sfr@canb.auug.org.au>
	<20081209153418.4628723d.akpm@linux-foundation.org>
	<ac3eb2510812091606k5615135fn87d35aaa16834ea8@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008 01:06:47 +0100
"Kay Sievers" <kay.sievers@vrfy.org> wrote:

> On Wed, Dec 10, 2008 at 00:34, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Tue, 9 Dec 2008 18:52:37 +1100
> > Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> >> I have created today's linux-next tree at
> >> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> >
> > udevd is sitting there chewing up 100% of a CPU all the time.
> >
> > The machine is x86_64, running FC6.  It still happens with
> > CONFIG_SELINUX=n.
> >
> > config:                 http://userweb.kernel.org/~akpm/config-akpm2.txt
> > dmesg:                  http://userweb.kernel.org/~akpm/dmesg-akpm2.txt
> > strace of udevd:        http://userweb.kernel.org/~akpm/strace.out.txt
> >
> > excerpt:
> >
> > close(9)                                = 0
> > open("/proc/21707/stat", O_RDONLY)      = 9
> > read(9, "21707 (hald-addon-stor) S 21033 "..., 255) = 240
> > close(9)                                = 0
> > open("/proc/22340/stat", O_RDONLY)      = 9
> > read(9, "22340 (smartd) S 1 22339 22339 0"..., 255) = 245
> > close(9)                                = 0
> 
> Maybe an event loop, caused by something.
> 
> Are you still able to run:
>   udevmonitor --kernel
> and see if we get events, maybe in a loop, from the kernel?
> 


akpm2:/home/akpm# udevmonitor --kernel
unknown option


(lol)

akpm2:/home/akpm# udevmonitor         
udevmonitor prints the received event from the kernel [UEVENT]
and the event which udev sends out after rule processing [UDEV]

UDEV  [1228867146.103334] add@/class/bdi/9:0
UDEV  [1228867146.107566] remove@/block/md0
UDEV  [1228867146.111969] remove@/class/bdi/9:0
UEVENT[1228867146.119889] add@/block/md0
UEVENT[1228867146.119964] add@/class/bdi/9:0
UEVENT[1228867146.120162] remove@/class/bdi/9:0
UEVENT[1228867146.120205] remove@/block/md0
UDEV  [1228867146.122839] add@/block/md0
UDEV  [1228867146.129125] add@/class/bdi/9:0
UDEV  [1228867146.133459] remove@/block/md0
UDEV  [1228867146.137813] remove@/class/bdi/9:0
UEVENT[1228867146.145652] add@/block/md0
UEVENT[1228867146.145709] add@/class/bdi/9:0
UEVENT[1228867146.145895] remove@/class/bdi/9:0
UEVENT[1228867146.145941] remove@/block/md0
UDEV  [1228867146.148606] add@/block/md0
UDEV  [1228867146.154832] add@/class/bdi/9:0
UDEV  [1228867146.159299] remove@/block/md0
UDEV  [1228867146.163750] remove@/class/bdi/9:0
UEVENT[1228867146.171354] add@/block/md0
UEVENT[1228867146.171391] add@/class/bdi/9:0
UEVENT[1228867146.171546] remove@/class/bdi/9:0
UEVENT[1228867146.171566] remove@/block/md0
UDEV  [1228867146.174242] add@/block/md0
UDEV  [1228867146.180730] add@/class/bdi/9:0
UDEV  [1228867146.185137] remove@/block/md0
UDEV  [1228867146.189435] remove@/class/bdi/9:0
UEVENT[1228867146.197278] add@/block/md0
UEVENT[1228867146.197330] add@/class/bdi/9:0
UEVENT[1228867146.197503] remove@/class/bdi/9:0
UEVENT[1228867146.197545] remove@/block/md0
UDEV  [1228867146.200025] add@/block/md0
UDEV  [1228867146.206571] add@/class/bdi/9:0
UDEV  [1228867146.210940] remove@/block/md0
UDEV  [1228867146.215359] remove@/class/bdi/9:0
UEVENT[1228867146.223278] add@/block/md0
UEVENT[1228867146.223336] add@/class/bdi/9:0
UEVENT[1228867146.223524] remove@/class/bdi/9:0
UEVENT[1228867146.223571] remove@/block/md0
UDEV  [1228867146.226163] add@/block/md0
UDEV  [1228867146.232415] add@/class/bdi/9:0
UDEV  [1228867146.236739] remove@/block/md0
UDEV  [1228867146.241042] remove@/class/bdi/9:0
UEVENT[1228867146.248895] add@/block/md0
UEVENT[1228867146.249012] add@/class/bdi/9:0
UEVENT[1228867146.249306] remove@/class/bdi/9:0
UEVENT[1228867146.249409] remove@/block/md0

