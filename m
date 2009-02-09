Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbZBITbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbZBITbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:31:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbZBITa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:30:58 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:31368 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbZBITa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:30:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=dwtqypfpuCWv25TOPvfYvc83ksZhgiqg7+OwLCvuiY5neA6IiYzCtgL9QbPkcwN4st
         vUffUmdpy3E95nIyBxIn9RuLhdLWn8YX6PS/oPcmhGmWJyXmOOJP6IFQ0Km0UCZX1YZU
         NhxDcVDG6KVkUBfpqouXsMMLexIS8AXXQKF7U=
MIME-Version: 1.0
Date: Mon, 9 Feb 2009 19:30:56 +0000
Message-ID: <b6a2d2e20902091130ha452a97rcfaa2972bfdbe710@mail.gmail.com>
Subject: cgroup, RT reservation per core(s)?
From: Rolando Martins <rolando.martins@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I would like to have in a quad-core, 2 cores totally (100%) dedicated
to RT tasks (SCHED_RR and SCHED_FIFO) and the other 2 cores with
normal behavior, better said,  allowing SCHED_OTHER & SCHED_FIFO &
SCHED_RR tasks but still with a RT reservation. Follows an example:


# Setup first domain (cpu 0,1)
echo 0-1 > /dev/cgroup/0/cpuset.cpus
echo 0 > /dev/cgroup/0/cpuset.mems

# Setup RT bandwidth for firstdomain (80% for RT, 20% others)
echo 1000000 > /dev/cgroup/0/cpu.rt_period_us
echo 800000 > /dev/cgroup/0/cpu.rt_runtime_us


# Setup second domain (cpu 2,3)
mkdir /dev/cgroup/1
echo 2-3 > /dev/cgroup/1/cpuset.cpus
echo 0 > /dev/cgroup/1/cpuset.mems

# Setup RT bandwidth for second domain (100% for RT)
echo 1000000 > /dev/cgroup/1/cpu.rt_period_us
echo 1000000 > /dev/cgroup/1/cpu.rt_runtime_us

Is there anyway for doing this?

Thanks,
Rol
