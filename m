Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbYATO3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbYATO3X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 09:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbYATO3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 09:29:14 -0500
Received: from powered.by.e-leven.be ([88.82.46.250]:41346 "EHLO
	queen.hive.selfip.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbYATO3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 09:29:13 -0500
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jan 2008 09:29:12 EST
Subject: inconsistent high io wait when reading from disk
From: AL13N <alien999999999@users.sourceforge.net>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.11
MIME-Version: 1.0
Importance: Normal
X-Length: 2591
Date: Sun, 20 Jan 2008 15:21:43 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801201521.43360.alien999999999@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(please CC me)

I am copying a large file +-1GB to another machine using scp, this was the
easiest way to reproduce.

I've done this a few dozen times, and there's few odd things about this:

sometimes i have read speeds of around 20MB/s, at that time, the CPU is
about 60% idle and max 10% io wait.

but mostly, i have read speeds around 5MB/s, and CPU is 0% idle and 70% io
waiting.

This is a little odd, but one could argue that there are lots of factors,
etc...

True, however, i should note that, allthough i ran the tests immediately
after each other; that if i had low IO wait less than 10%, it stayed that
way, until the file was completely copied. AND if i had IO wait higher
than 50%, it also stayed that way until the file was copied; immediately
after all copies, there is no IO wait. even when no other process is
writing for several seconds, this continues. same things with the speeds,
either i have a consistent 5MB/s read, or 20MB/s read; never in between or
fluctuating.

I've tried to eliminate lots of other possibilities, by doing cat
/path/to/file >/dev/null ; to just do the IO reading; usually this makes a
extremely high io waiting (around 90%), but the read speeds are the same,
either around 5 or around 20.

stats are observed through iostat and mpstat. (in slow or normal case:
iostat -x gives sda total usage 100%)

I would like to trace this io wait to what process and device (I'm fairly
sure it's the process i'm testing this with (eg: scp or cat)). but i don't
know such a utility to find it.

I've tried to google on this, but allthough there is lots of stuff with
high IO wait in it. no solutions seems to be present.

now, i can accept that sometimes, it's just slow. but the inconsistency is
too consistent to be normal.

can anyone give me some constructive info/help on this?

thanks in advance

-- 
AL13N is my name and head-biting is my game.
