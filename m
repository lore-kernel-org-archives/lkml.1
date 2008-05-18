Return-Path: <linux-kernel-owner+w=401wt.eu-S1761358AbYERSyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761358AbYERSyM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758997AbYERSsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:48:16 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:53161 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759346AbYERSsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:48:11 -0400
X-Sasl-enc: 7prNOFE/AVUp0ivXeBOYyWTsnnORs3ryeUXmn7sc9n52 1211136490
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>, Thomas Renninger <trenn@suse.de>
Subject: [RFC] rfkill class rework
Date: Sun, 18 May 2008 15:47:50 -0300
Message-Id: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch series contains what is ready so far of my rfkill rework
effort.

Much has been talked about it already, please refer to the thread started
by Message-Id: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br>
(http://thread.gmane.org/gmane.linux.kernel/664500) if you don't understand
what brought this on.

In particular, anyone that still thinks drivers can use the input layer to
send rfkill state change messages around, or that rfkill class and
input-polldev work as a way to have read/write rfkill switches, go read
that thread... Fixing this is about half the reason why this patchset
exists (the other being that thinkpad-acpi needs it, and therefore I need
it as an user and also as a kernel developer).

This series is available as a git branch at:
git://repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git rfkill

The first two patches are just to sync the pending-merge queue of
thinkpad-acpi to avoid wasting my time with various versions of other
patches because of two patches that will hit mainline very soon.  Do not
pay too much attention to them.

The input layer patch is already approved by Dmitry, but he asked me to
merge it along with the rest of the stuff that needs it.

The full rfkill work is NOT complete.  The userspace interface is lacking a
way to read and write to the global rfkill switch states, in order to let
userspace do all that rfkill-input.c can do (i.e. something like the
private rfkill_switch_all and rfkill_epo).  I do have some patches that do
it, but I am not happy with them.  I will send them later, please comment
on this "supposedly to be ready for merging" patch set first.

As it stands, I'd like to know if the patches in this series are acceptable
to go upstream.  They do NOT break anything further in the kernel, but they
don't fix any drivers by themselves either (the drivers, like b43, need to
be fixed to use the rfkill class properly).

If you need a 2.6.23 (might also work on 2.6.24 and 2.6.25) backport of
this series, OR if you want to play with a modified thinkpad-acpi that uses
these rfkill changes, please look at:
git://repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git devel

Comments are appreciated.  The sooner this set of rfkill changes can begin
the merge process, the better.  I'd *really* like to see them merged in
mainline during the 2.6.27 merge window (so that I can do the same with the
rfkill support in thinkpad-acpi).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
