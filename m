Return-Path: <linux-kernel-owner+w=401wt.eu-S1759688AbYALTse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759688AbYALTse (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 14:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbYALTs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 14:48:26 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:39267 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbYALTsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 14:48:25 -0500
Date: Sat, 12 Jan 2008 11:48:24 -0800 (PST)
From: dean gaudet <dean@arctic.org>
To: linux-kernel@vger.kernel.org
Subject: nosmp/maxcpus=0 or 1 -> TSC unstable
Message-ID: <alpine.DEB.0.999999.0801121142370.11727@twinlark.arctic.org>
User-Agent: Alpine 0.999999 (DEB 847 2007-12-06)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if i boot an x86 64-bit 2.6.24-rc7 kernel with nosmp, maxcpus=0 or 1 it 
still disables TSC :)

Marking TSC unstable due to TSCs unsynchronized

this is an opteron 2xx box which does have two cpus and no clock-divide in 
halt or cpufreq enabled so TSC should be fine with only one cpu.

pretty sure this is the culprit is that num_possible_cpus() > 1, which 
would mean cpu_possible_map contains the second cpu... but i'm not quite 
sure what the right fix is... or perhaps this is all intended.

-dean
