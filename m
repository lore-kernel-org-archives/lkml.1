Return-Path: <linux-kernel-owner+w=401wt.eu-S1751674AbXDKJ1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbXDKJ1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 05:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbXDKJ1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 05:27:14 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:60386 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbXDKJ1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 05:27:07 -0400
X-Originating-Ip: 74.109.98.130
Date: Wed, 11 Apr 2007 05:25:53 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "menu" versus "menuconfig" -- they're *both* a bad idea
In-Reply-To: <Pine.LNX.4.61.0704111059190.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.64.0704110509200.11343@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0704110357200.9384@CPE00045a9c397f-CM001225dbafb6>
 <Pine.LNX.4.61.0704111059190.32056@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007, Jan Engelhardt wrote:

>
> On Apr 11 2007 03:58, Robert P. J. Day wrote:
> >
> >  General setup
> >    [ ] Configure standard kernel features (for small systems)  --->
> >
> >note how, even if you don't choose to configure features for small
> >systems, if you go under that menu entry, you're still presented with
> >a couple config options related to kallsyms.
>
> A CONFIG_EMBEDDED bug. This should perhaps be changed.
> Or at best, deactivate the ---> part when it's N.

  i'm not sure what you mean by "bug".  if what you mean is that it's
a bad choice of menu layout, i agree.  but what's happening there is
not technically "wrong" or "buggy" in the sense that it's perfectly
legal based on the current design of "menuconfig".

  even though you choose to deselect "small features," that submenu
continues to display two selectable options for the simple reason that

1) they don't depend on CONFIG_EMBEDDED (clearly bad design), and

2) they're being forcibly "select"ed by other options elsewhere in the
tree

  i think this should be avoided as much as possible, which is why i
suggested a whole new menu construct such as "dropdownmenuconfig" or
something equally annoying -- such a construct would *enforce* good
design by not even *allowing* the silliness that is that "small
features" menu.  by automatically adding the appropriate dependency to
every single sub-option, it would not only make the Kconfig file
prettier, it would prevent what you can currently do in places like
that "small features" menu -- allowing options elsewhere in the tree
to explicitly override your choices.

  (in short, if i, the builder, explicitly choose *not* to add a
certain feature to my build, i think i have every right to expect that
some other part of my configuration isn't quietly going to put some
sub-choice of that feature back in behind my back.)

  of course, there will be times where you need to something weird for
which the proposed behaviour of "dropdownmenuconfig" isn't
appropriate.  cases like that should be viewed as *aberrations* and
they can always be hacked manually if you really need to do that.  but
i think it would be cleaner to just introduce a new construct that
Does The Right Thing 98% of the time and makes for a more intuitive
design.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
