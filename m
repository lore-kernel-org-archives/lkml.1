Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbYCVCcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbYCVCcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 22:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbYCVCcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 22:32:16 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:8518 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbYCVCcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 22:32:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:date:message-id:sender;
        b=lBhJdRbhDyj2mBj0njU/N0p8CZXfXMMemiCF0zUf0jetjt5utR7BqiC0jY7gVCtdUJ+84IdwSKsPw+yqCTynt4ObVdqailpB/R6oF0U+qnbetzwFYF4x4Ej6SxezLBYhUCJ4H0zgbzXv4gDLrdQ7Bf7arvQUqZ33qSH83mjHxMk=
Subject: [RFC][PATCH 0/9] cgroups: block: cfq: I/O bandwidth controlling subsystem for CGroups based on CFQ
From: Vasily Tarasov <vtaras@openvz.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, devel@openvz.org,
       containers@linux-foundation.com, dev@openvz.org, xemul@openvz.org,
       vtaras@openvz.org
Date: Fri, 15 Feb 2008 01:53:34 -0500
Message-Id: <1203058414.042372.2088.nullmailer@me>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasily Tarasov <vtaras@openvz.org>

The following patchset introduces I/O bandwidth controlling subsystem
for the CGroups framework based on the CFQ scheduler.
User can assign a priority from 0 to 7 to a cgroup, and I/O bandwidth
will be adjusted proportionally.
This effect is achieved by introducing a certain modifications to CFQ.
Now there is not only per process time slice, but also per cgroup
time slice. During cgroup's time slice only processes from current
cgroup can add requests to the queue. Inside cgroups's time slice
processes are managed based on (per-process) time slices (as usual in CFQ).
This is why we call this approach "two level CFQ".

Such kind of system works in OpenVZ project.

Patch is against 2.6.25-rc2-mm1

Comments, suggestions, criticism are all welcome.
