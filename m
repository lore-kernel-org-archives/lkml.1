Return-Path: <linux-kernel-owner+w=401wt.eu-S1756314AbXD2Jha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314AbXD2Jha (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 05:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756316AbXD2Jha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 05:37:30 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41972 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755121AbXD2Jh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 05:37:29 -0400
Date: Sun, 29 Apr 2007 02:37:21 -0700
From: Paul Jackson <pj@sgi.com>
To: menage@google.com
Cc: akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, ebiederm@xmission.com, haveblue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, balbir@in.ibm.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, containers@lists.osdl.org,
       devel@openvz.org
Subject: Re: [PATCH 0/9] Containers (V9): Generic Process Containers
Message-Id: <20070429023721.53f249b9.pj@sgi.com>
In-Reply-To: <20070427104607.252541000@menage.corp.google.com>
References: <20070427104607.252541000@menage.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm afraid that this patch set doesn't do cpusets very well.

It builds and boots and mounts the cpuset file system ok.
But trying to write the 'mems' file hangs the system hard.

I had to test it against 2.6.21-rc7-mm2, because I can't boot
2.6.21-rc7-mm1, due to the 'bad_page' problem that I noted in an
earlier post this evening on lkml.

These container patches seemed to apply ok against 2.6.21-rc7-mm2,
and built and booted ok.  I built with an sn2_defconfig configuration,
having the following CONTAINER and CPUSET settings:

    CONFIG_CONTAINERS=y
    CONFIG_CONTAINER_DEBUG=y
    CONFIG_CPUSETS=y
    CONFIG_CONTAINER_CPUACCT=y
    CONFIG_PROC_PID_CPUSET=y
    # CONFIG_ACPI_CONTAINER is not set

I could mount the cpuset file system on /dev/cpuset just fine.

Then I invoked the following commands:

    # cd /dev/cpuset
    # mkdir foo
    # cd foo
    # echo 0-3 > cpus
    # echo 0-1 > mems

At that point, the system hangs.  Reproduced three times, on two boots.
I never get a shell prompt back from that second echo.  I have to hit
Reset.  The three different hangs were done with the following three
different values:

	echo 0-3 > mems
	echo 0-1 > mems
	echo 1 > mems

On that last one, "echo 1 > mems", I did not do the echo to cpus first.

The test system had 8 cpus, numbered 0-7, and 4 mems, numbered 0-3.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
