Return-Path: <linux-kernel-owner+w=401wt.eu-S1758014AbYEPPxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbYEPPxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 11:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbYEPPx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 11:53:26 -0400
Received: from main.gmane.org ([80.91.229.2]:51228 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbYEPPxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 11:53:25 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: Weird Xorg stretching (setfont)
Date: Fri, 16 May 2008 16:53:08 +0100
Message-ID: <g0kal5$f5v$1@ger.gmane.org>
References: <g0hflu$b4q$1@ger.gmane.org> <482C744C.3050308@redhat.com> <g0iadj$dip$1@ger.gmane.org> <21d7e9970805151618i71ccc581j7e07082bd0b7a8e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-cwma5-0-0-cust137.swan.cable.ntl.com
User-Agent: KNode/0.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:

> wierd got any fglrx or anything installed on you're system.. the
> radeon drm hasn't seen any changes that should affect this sorta
> thing, do you run radeonfb or vesafb?

Just in case you didn't see my reply I'm not an fglrx user and I don't run
radeonfb or vesafb.

After testing far too many kernels it turns out that this is not a
conventional regression. During startup openSUSE runs the following
command:

/bin/setfont -C /dev/tty1 lat9w-16.psfu -m trivial

in /etc/init.d/kbd

Now on the openSUSE provided 2.6.22.17-0.1-default #1 SMP kernel if X has
started and your run that command (e.g.
chvt 7; sleep 5s && /bin/setfont -C /dev/tty1 lat9w-16.psfu -m trivial
) the command will fail with error output similar to the following:
setfont: putfont: 256,8x16: failed: -1
putfont: KDFONTOP: Invalid Argument

If you are using a stock kernel (e.g. 2.6.24/2.6.25 etc) the command will
not fail and will instead corrupt X causing the lower part of the screen to
be drawn using the same line (creating a stretch/mirror effect).

There seems to be a bit of mention of this over in
https://bugzilla.novell.com/show_bug.cgi?id=335267 but that talks about it
failing (which I consider to be better behaviour than corrupting X).

The whole thing is racy on boot (e.g. if setfont happens before X is shown
then there is no corruption) fooling me into thinking it was a regression.

-- 
Sitsofe

