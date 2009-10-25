Return-Path: <linux-kernel-owner+w=401wt.eu-S1754343AbZJYWqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbZJYWqB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 18:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754331AbZJYWqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 18:46:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:32780 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbZJYWqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 18:46:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=bTclYjSec78lgR+fOtk2qlrtJ/aaHINTi3F+lbFyoSKMr0m5ssvZdTSFaY50t2OG0a
         yZH43ZJQ2E+Xqp8wxE3B0ja4RWuF176NSs9kZAtxoY1UUI0KYiJisN6vXo5ffL0PrkMS
         57N6zoDAauwiHlVnLXLm22bxPe6hNX2wt4Bqs=
MIME-Version: 1.0
Date: Sun, 25 Oct 2009 18:46:03 -0400
Message-ID: <deaa866a0910251546m7ea001bcm252c41e65927a424@mail.gmail.com>
Subject: Broken ondemand scheduler in Linux 2.6.30+ on Pentium IVs
From: Robert Bradbury <robert.bradbury@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Somewhere in the Linux 2.6.30+ patches was a change to
"arch/x86/kernel/cpu/cpufreq/
p4-clockmod.c" which changed (around line 253) such that
  policy->cpuinfo.transition_latency = 1000000; /* assumed */
became
  policy->cpuinfo.transition_latency = 10000001;

This prevents the ondemand scheduler from being adopted and working
correctly (on a system with the Gnome CPU Frequency Monitor).  The
reports I have received regarding *why* this change was made are
cryptic at best.

I will state that *before* the change CPU frequency scaling did work,
the monitor shows the changes and it is reflected at the wall socket
(measured power consumption on a Pentium IV system dropped from ~135W
to ~105W when ondemand scheduling dropped the CPU frequency from 2.8
GHz down to 350-700 MHz -- which is works fine for most lightly used
but need-to-be-on 24/7 web server systems [1].

This change makes Linux less "green" IMO and I would like to know why
it was implemented and/or if it was implemented without bother to
integrate it with the utility developers that are trying to
develop/manage CPU power use at the user level.  In this day and age,
one should *not* break power consumption reducing features in the O.S.
without significant documentation as to how and why.

It is worth noting that changing this single line of code back does
restore the power conserving features of the "ondemand" scheduler.

Robert

1. For more information see: Gentoo Bug #287463 "Kernel modifications
break ondemand frequency scaling from conserving power" @ the gentoo
bug database (the URL for which was rejected due to LKML security
policies) [2]
2. One would think that the LKML could verify and accept the security
of various bugzilla based bug reporting systems since reporting bugs
this way on the LKML is very, *very* old school.
