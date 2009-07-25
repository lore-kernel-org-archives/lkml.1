Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbZGYN1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbZGYN1q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 09:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbZGYN1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 09:27:46 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:48952 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbZGYN1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 09:27:45 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: linux-kernel@vger.kernel.org
Subject: [VIA Support]  Instruction timing and cache coherency issues
Date: Sat, 25 Jul 2009 08:27:39 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907250827.43400.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Started back in mid-May - long time and a lot of hours later...

As suggested very early in this examination by others -
It is a timing issue.  My inserting "lock" for config_mviac7
was just poking at the edges of the sore spot.  ;)

The "break through" came yesterday while running (or trying to run)
FreeBSD-8.0-beta2 on the various machines at hand. . .

Depending on the cpu model variation and the integrated chipset
used with that cpu - -
*) FB-8.0 will run
*) FB-8.0 will only run in "safe mode"
*) FB-8.0 panics

And that pattern is similar to the 2.6.30 cpu model / chipset pattern.
Scratches head, asking: "now how can that be" with two very different OS designs.

Diddling with the things I have found that either "fix" or "work around"
the various timing / cache coherency issues - - -
Aw, so - found how to affect the timing issues sufficiently so that Linux
would panic dump rather than deadlock on the troublesum combination - -
*Functionally the same* panic backtrace that FreeBSD is showing.

NOW I have a lead into making a "minimum invasive" change so that the 
kernel is happy - even on the flaky VIA combinations.  Patch RSN, just any month.
The FreeBSD project can fix their problems themselves.  ;)

@H.W.  Download the FreeBSD-8.0-beta2 and try running it on your Cloudbook and HP-2133,
you can see what is happening.  Then you might have a word or two with the silicon growers.

Mike
