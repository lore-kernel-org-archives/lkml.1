Return-Path: <linux-kernel-owner+w=401wt.eu-S1756813AbYFCLQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbYFCLQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 07:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbYFCLQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 07:16:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbYFCLQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 07:16:27 -0400
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 0/3] have pooled sunrpc services make more intelligent
	allocations
To: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       bfields@fieldses.org
Date: Tue, 03 Jun 2008 07:16:09 -0400
Message-ID: <20080603110549.8631.46647.stgit@dantu.usersys.redhat.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sunrpc code has had some support for spreading pooled services over
different NUMA nodes and CPUs for some time. So far though, this support
has been for CPU masks only. Memory allocated for these services is
generally done by whatever CPU happens to be running the init script
that starts the services and so most of it ends up on the same NUMA node.
This means that nfsd's end up wasting a lot of time updating remote
memory on a different memory node.

This patchset attempts to remedy that by having pooled services make
per-thread allocations that are on their local memory node. I have no
hard performance numbers for this particular patchset, but Greg Banks
sent me a different patch that has a similar effect and claims that
there is a significant performance gain.

Comments and suggestions appreciated...

Signed-off-by: Jeff Layton <jlayton@redhat.com>
