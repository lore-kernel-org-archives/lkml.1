Return-Path: <linux-kernel-owner+w=401wt.eu-S1757516AbZCDV4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbZCDV4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 16:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbZCDV4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 16:56:00 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:50694 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbZCDVz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 16:55:59 -0500
Date: Wed, 4 Mar 2009 22:55:56 +0100
From: Arjan Opmeer <arjan@opmeer.net>
To: dtor@mail.ru, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20090304215556.GA16612@adopmeer.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Subject: How to handle Elantech touchpad that occasionally sends bogus
	coordinates?
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Recently a user complained that when using the Elantech driver the mouse
pointer would occasionally jump some distance away, or that when scrolling
the scrolled page would suddenly jump back a bit.

It turns out that when starting a new touch action on this particular model
the touchpad does not reliably emit the new coordinates but can repeat one
or two of the coordinates of the last release point. This misreporting can
last several motion packets depending on the number of fingers that are
touching.

We came up with a workaround that basically discards mouse packets as long
as the number of fingers is increasing. Like so:


   if (fingers > old_fingers) {
       discard packet
   }

With this fix in place the user no longer suffers from the jumpy mouse
cursor or the jumpy scrolling. He reports no impact on the responsiveness of
the touchpad.

My question now is whether this is the right approach to fix this issue? Is
such a workaround acceptable and should it live in the kernel? Can or should
this problem be better solved in the Xorg Synaptics driver?

Comments please! :)


Arjan
