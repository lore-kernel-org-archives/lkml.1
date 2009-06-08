Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbZFHMrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbZFHMrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 08:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbZFHMq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 08:46:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:27655 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbZFHMq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 08:46:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,324,1241420400"; 
   d="scan'208";a="151802099"
Date: Mon, 8 Jun 2009 20:46:43 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Nai Xia <nai.xia@gmail.com>
Cc: "gnome-list@gnome.org" <gnome-list@gnome.org>,
       Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       "xorg@lists.freedesktop.org" <xorg@lists.freedesktop.org>
Subject: Re: [PATCH 2/3] vmscan: make mapped executable pages the first
	class  citizen
Message-ID: <20090608124643.GA8079@localhost>
References: <alpine.DEB.1.10.0905181045340.20244@qirst.com> <20090519032759.GA7608@localhost> <20090519133422.4ECC.A69D9226@jp.fujitsu.com> <20090519062503.GA9580@localhost> <87pre4nhqf.fsf@basil.nowhere.org> <20090520143258.GA5706@localhost> <20090520144731.GB4753@basil.nowhere.org> <20090520145607.GA6281@localhost> <20090520153851.GA6572@localhost> <ab418ea90906080514k6f46d3fay6a5fe0b848c8ca50@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ab418ea90906080514k6f46d3fay6a5fe0b848c8ca50@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 08:14:53PM +0800, Nai Xia wrote:
> On Wed, May 20, 2009 at 11:38 PM, Wu Fengguang<fengguang.wu@intel.com> wrote:
> > Hi list,
> >
> > On Wed, May 20, 2009 at 10:56:07PM +0800, Wu Fengguang wrote:
> >> On Wed, May 20, 2009 at 10:47:31PM +0800, Andi Kleen wrote:
> >> > > > One scenario that might be useful to test is what happens when some
> >> > > > very large processes, all mapped and executable exceed memory and
> >> > >
> >> > > Good idea. Too bad I may have to install some bloated desktop in order
> >> > > to test this out ;) I guess the pgmajfault+pswpin numbers can serve as
> >> > > negative scores in that case?
> >> >
> >> > I would just generate a large C program with a script and compile
> >> > and run that. The program can be very dumb (e.g. only run
> >> > a gigantic loop), it just needs to be large.
> >> >
> >> > Just don't compile it with optimization, that can be quite slow.
> >> >
> >> > And use multiple functions, otherwise gcc might exceed your memory.
> >>
> >>
> >> Hehe, an arbitrary C program may not be persuasive..but I do have some
> >> bloated binaries at hand :-)
> >>
> >> -rwsr-sr-x 1 root wfg   36M 2009-04-22 17:21 Xorg
> >> lrwxrwxrwx 1 wfg  wfg     4 2009-04-22 17:21 X -> Xorg
> >> -rwxr-xr-x 1 wfg  wfg   39M 2009-04-22 17:21 Xvfb
> >> -rwxr-xr-x 1 wfg  wfg   35M 2009-04-22 17:21 Xnest
> >
> > I would like to create a lot of windows in gnome, and to switch
> > between them. Any ideas on scripting/automating the "switch window"
> > actions?
> 
> You can easily do this in KDE 3.5 with dcop(Desktop Communications Protocol)\
> 
> e.g.
> 
> $dcop kchmviewer-17502 KCHMMainWindow raise
> 
> will raise the window of my kchmviewer.

Thank you, it's a good tip :)

The alternative I found is wmctrl:

Description: control an EWMH/NetWM compatible X Window Manager
 Wmctrl is a command line tool to interact with an
 EWMH/NetWM compatible X Window Manager (examples include
 Enlightenment, icewm, kwin, metacity, and sawfish).
 .
 Wmctrl provides command line access to almost all the features
 defined in the EWMH specification. For example it can maximize
 windows, make them sticky, set them to be always on top. It can
 switch and resize desktops and perform many other useful
 operations.

Thanks,
Fengguang
