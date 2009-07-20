Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456AbZGTXqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbZGTXqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 19:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbZGTXqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 19:46:21 -0400
Received: from solo.fdn.fr ([80.67.169.19]:34688 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273AbZGTXqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 19:46:21 -0400
Date: Tue, 21 Jul 2009 01:46:18 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
Subject: inotify on /dev/vcsa?
Message-ID: <20090720234618.GR5397@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Powersaving is everywhere, including accessibility.  User-level daemons
use /dev/vcsa to know what text is displayed on the screen.  Problem
is: there is no way to _wait_ for an update to happen, so these daemons
actually poll every e.g. 40ms so as to be reactive enough for smooth
user experience.  That means waking up 25 times per second, which is not
so greenish while the computer could be completely idle else.

An ioctl could be devised to wait for updates, but I was wondering
if there could be a way to just use inotify for that.  However,
drivers/char/vc_screen.c would have to collect the list of opened files
in order to notify all of them (processes may even have opened another
node with same devno as /dev/vcsa), which is not really pretty, and
actually maybe some other device drivers would want to achieve the same
kind of thing, so I was wondering whether that could fit into another
place like the generic device infrastructure?

Samuel
