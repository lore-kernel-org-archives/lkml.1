Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350AbZKPSn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbZKPSn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 13:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbZKPSn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 13:43:58 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:59874 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752373AbZKPSn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 13:43:57 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAF4qAUtGGN1W/2dsb2JhbACBTtVlhDwEgW0
Date: Mon, 16 Nov 2009 13:44:01 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org
Subject: [RELEASE] LTTng 0.170 for kernel 2.6.31.6 (bugfix release,
	stress-test)
Message-ID: <20091116184401.GC9854@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 13:35:47 up 90 days,  5:25,  5 users,  load average: 0.04, 0.14,
	0.21
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just released lttng 0.170 which fixes concurrency problems between:

cpu hotplug
trace start/stop
marker arm/disarm

All users using LTTng since 0.165 (where the refactoring has been done)
are strongly encouraged to upgrade.

The stress-tests I have done are (in parallel):

#cpu hotplug
for b in $(seq 1 1000); do
  for a in $(find /sys/devices/system/cpu |grep online); do
    echo 0 > $a;
  done;
  for a in $(find /sys/devices/system/cpu |grep online); do
    echo 1 > $a;
  done;
done

#ltt-armall
for a in $(seq 1 1000); do
  /home/compudj/local/bin/ltt-armall;
  /home/compudj/local/bin/ltt-disarmall;
done

#trace creation/removal
for a in $(seq 1 1000); do
  rm -fr /tmp/trace2;
  /home/compudj/local/bin/lttctl -C -w /tmp/trace2 trace2;
  /home/compudj/local/bin/lttctl -D trace2;
done

Works fine now. I'll leave the test run longer, but about 10 minutes of
these running in parallel is fine now.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
