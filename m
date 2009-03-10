Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbZCJLt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbZCJLt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 07:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbZCJLts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 07:49:48 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:22201 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbZCJLtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 07:49:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=B1QBXCJzABjQhDdOjhNKZ/i76Rsv2qcqL4q/59eeV4LGn2JF3GLZf4h3814kw+9nnK
         AgRyiWZzefSzc2UYyFeTNjr5pFhQsLZOAEW6DPtK7iQy4Y2taw75dx2mIzScXp7UaR+U
         PufHWsErrFRpEB5yZHvRgMzT82J2ekLcSZjlo=
MIME-Version: 1.0
Date: Tue, 10 Mar 2009 11:49:45 +0000
Message-ID: <b6a2d2e20903100449k7bb325eau26ad724e6303080b@mail.gmail.com>
Subject: cgroup, balance RT bandwidth
From: Rolando Martins <rolando.martins@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to confirm, cpuset.sched_load_balance doesn't work with RT, right?
You cannot have tasks for sub-domain 2 to utilize bandwidth of
sub-domain 3, right?

                              __1__
                             /        \
                            2         3
                      (50% rt)  (50% rt )

For my application domain it would be interesting to have
rt_runtime_ns as a min. of allocated rt and not a max.
Ex. If an application of domain 2 needs to go up to 100% and domain 3
is idle, then it would be cool to let it utilize the full bandwidth.
(we also could have a hard upper limit in each sub-domain, like
hard_up=0.8, i.e. even if we could get 100%, we will only utilize
80%); in other words, rt having the same cpu bandwidth management behavior
as the "best-effort" tasks.

Could this be done?

Rolando
