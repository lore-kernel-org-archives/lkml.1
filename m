Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbYGaMXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbYGaMXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 08:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbYGaMXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 08:23:41 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:5840 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbYGaMXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 08:23:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X2Fi00bDy2OFVsp/QZMPeDjppkd2sd5UTMzaoKc7ysYT8PYGJ05wC54hxBhHDLoS+d
         1pDSff3wtzPtscGEk6HFBe8GZzoJU4NqAyC91YhFqPye79KG3I/D0O0bIsosozFlVlwq
         K/wHgTgIpNIXFIJZymSloKaHkgbc4ZtqqpLjg=
Date: Thu, 31 Jul 2008 16:23:36 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.27-rc1-mm1: busyloop time-schedule
Message-ID: <20080731122336.GA5511@martell.zuzino.mipt.ru>
References: <20080731000354.24b55d5b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080731000354.24b55d5b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only suspicious thing so far is 100% CPU during "time-schedule" test
from LTP:

	[...]
pth_str03    0  INFO  :  thread 0 exiting, depth=4, status=0, addr=0xf2b010
pth_str03    0  INFO  :  The sum of tree (breadth 4, depth 3) is 3570
pth_str03    1  PASS  :  Test passed
<<<execution_status>>>
duration=0 termination_type=exited termination_id=0 corefile=no
cutime=0 cstime=3
<<<test_end>>>
<<<test_start>>>
tag=time-schedule01 stime=1217504927
cmdline="       time-schedule"

	[100% CPU here, reproducible]

"strace -p" kicks the test to completion, and shows plenty of
sched_yield() calls, IIRC.

