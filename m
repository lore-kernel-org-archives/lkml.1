Return-Path: <linux-kernel-owner+w=401wt.eu-S1765491AbXILHw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765491AbXILHw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 03:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757059AbXILHwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 03:52:21 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:45903 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbXILHwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 03:52:20 -0400
X-Originating-Ip: 72.143.66.27
Date: Wed, 12 Sep 2007 03:50:17 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: stripping down the kernel-parameters.txt file
Message-ID: <Pine.LNX.4.64.0709120339470.26177@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.723, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	TW_BT 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  while killing some time between compiles and ridding the
kernel-parameters.txt file of out-of-date or incorrect cruft, it
occurs to me that that file is borderline valueless since it
apparently tries to document every possible boot-time parameter,
including those associated with individual modules.  that's just
silly.

  it would make far more sense if that file restricted itself to just
those parameters that you'd consider fundamental or basic -- those
defined with one of "__setup()" or "early_param()" that would apply to
most users.

  instead, you find stuff like this (a random example):

  bttv.card=      [HW,V4L] bttv (bt848 + bt878 based grabber cards)
  bttv.radio=     Most important insmod options are available as
                  kernel args too.
  bttv.pll=       See Documentation/video4linux/bttv/Insmod-options
  bttv.tuner=     and Documentation/video4linux/bttv/CARDLIST

not to belittle the bttv module but, really, is that information
worthy of being recorded in the top-level parms.txt file?  and if
you're going to be consistent, you'd want to do that for every single
module and its respective throughout the tree, at which the parms.txt
file collapses under its own weight from forever being updated and has
so much information that it's impossible to find the useful stuff.

  i suggest that that file record only the basic boot-time params, and
the documentation for module-specific parameters be moved closer to
the module source itself.  there's no point in that poor file trying
to keep up with all of the module development in the tree.

rday

p.s.  and, while we're at it, folks might like to start replacing
the calls to "__setup()" in their driver code with the newer module
parameters mechanism.  it's just a thought.  :-)


-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
