Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596AbYJDFz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbYJDFz1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 01:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbYJDFzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 01:55:18 -0400
Received: from phunq.net ([64.81.85.152]:42897 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751057AbYJDFzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 01:55:17 -0400
From: Daniel Phillips <phillips@phunq.net>
To: linux-kernel@vger.kernel.org
Subject: Tux3 Report: It's What Next time once again
Date: Fri, 3 Oct 2008 22:55:12 -0700
User-Agent: KMail/1.9.5
Cc: tux3@tux3.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810032255.13117.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today was one of those skate-in-the-dark kind of days here in Paradise, 
but whereas the Tux3 cabal quite enjoys the occasional dimly lit 
runabout in the concrete jungle, we make it a point not to keep you, 
loyal readers, in the dark about upcoming Tux3 development directions.

The past three week's work made something of a liar of me, as we 
completely ignored the task of integrating versioned pointers that I 
had talked about earlier.  Instead, the Cabal decided that we would be 
better served by putting the effort into extents, in the interest of 
benchmarking well right from the start.

In fact, Tux3 will never actually have versioned pointers, but rather 
versioned extents, a much more ambitious proposition and messy enough 
that we now plan to defer that coding until some time after the initial 
kernel port, which is now expected to land with atomic commit and 
extended attributes but without versioning.  Another way of putting it: 
I promised to cut corners by leaving something for later, and that 
something is going to be versioning.  Tux3 will thus first arrive in 
kernel as more or less a functional equivalent of Ext3 (with bigger 
limits and shiny atom thingies) instead of something more exotic.

Atomic commit is a biggish project in its own right.  As with xattr 
atoms and certain aspects of the extent strategy, we forge into 
unexplored territory here with some new ideas on how to handle this 
tricky task robustly and efficiently.  The concept of forward logging, 
which is just one part of the planned mechanism, was described in the 
original Tux3 announcement:

   http://lkml.org/lkml/2008/7/23/257

Other pieces of the puzzle were described as part of the discussions 
with Matt Dillon comparing the designs of Tux3 and Hammer[1]:

   http://tux3.org/pipermail/tux3/2008-July/000012.html
   "Comparison to Hammer fs design"

   http://tux3.org/pipermail/tux3/2008-July/000014.html
   http://tux3.org/pipermail/tux3/2008-July/000018.html
   "Two kinds of atomic commit"

Many thanks to Matt for forcing me to be clear about certain essential 
details.

Now it is about time to put the pieces together to create a new 
algorithm which one might call "Son of Phase Tree".  The end goal of 
this effort is to approach media speed for both data and metadata 
commits, while controlling read fragmentation effectively.

Regards,

Daniel

[1] By the way, somebody should port Hammer to Linux.
