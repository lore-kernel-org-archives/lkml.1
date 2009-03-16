Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbZCPK4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbZCPK4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 06:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbZCPK4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 06:56:07 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:16016 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbZCPK4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 06:56:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=xHwuTiIbzlDDdvwLhiNDVLUzzyuM0y2Wcg9pjodi10xoFJNk8fMFQsX8xgJz+Oopcg
         c80yFLXVmlLmNi7NJAVuiq/XT9gzLjLHJCBs6nTfPsNqQNy9mi+Gi2aIubfXKl+2JBsZ
         79j4oikU5MJl/Fq2j/NRNMtZWoo12yXjwA0Ho=
MIME-Version: 1.0
Date: Mon, 16 Mar 2009 10:56:04 +0000
Message-ID: <b6a2d2e20903160356y67db8472k43577d706a393d96@mail.gmail.com>
Subject: cgroup, RT cpu balance question
From: Rolando Martins <rolando.martins@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have one question regarding RT cpu balance using cgroup.

cgroup
echo 1 > cpuset.sched_load_balance

cgroup/2
echo 0 > cpuset.mems
echo 0-2 > cpuset.cpus
echo 450000 > cpu.rt_runtime_us

cgroup/3
echo 0 > cpuset.mems
echo 3 > cpuset.cpus
echo 450000 > cpu.rt_runtime_us


I have a small test that uses a loop to utilize 100% cpu (SCHED_FIFO).
When I run 2 tests on cgroup/3, it only uses bandwidth from cpu 3
(100%), the balancing isn't happening.
As I use the SCHED_FIFO, the 2 processes run sequentially.

Is this the expected behavior? Shouldn't the domains balance the spare
cpu bandwidth?

Thanks,
Rolando
