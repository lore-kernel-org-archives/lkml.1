Return-Path: <linux-kernel-owner+w=401wt.eu-S1752529AbZJQPsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbZJQPsa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 11:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbZJQPsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 11:48:30 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:1069 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbZJQPs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 11:48:29 -0400
Date: Sat, 17 Oct 2009 17:48:33 +0200
From: Olivier Galibert <galibert@pobox.com>
To: "Hack inc." <linux-kernel@vger.kernel.org>
Subject: Regressions between 2.6.30.2 and 2.6.31.4
Message-ID: <20091017154833.GA40799@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	"Hack inc." <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just updated from 2.6.30.2 to 2.6.31.4 and I had the dubious
pleasure to find out that the "don't change user interfaces" principle
has been ignored once again.

Stopping rfkill for wlan0 was:
  echo 1 > /sys/class/net/wlan0/device/rfkill/rfkill*/state

now it's:
  echo 1 > /sys/class/net/wlan0/device/ieee80211/phy*/rfkill*/state

and it was different for 29.4 (no /rfkill/ subdirectory).  What will
it be for 32?  Bets are open.


As for my sound card (intel hda), looks like someone decided to add
two controls for jack presence detection *in* *the* *middle* of the
existing controls.  Numbered controls, mind you, because somehow names
must be too complex to use.  That made alsactl decide not to restore
my levels.  Always pleasant.

Will the alsa and the sysfs-using guys ever bother with compatibility?

  OG.
