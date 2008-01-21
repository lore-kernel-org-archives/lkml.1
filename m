Return-Path: <linux-kernel-owner+w=401wt.eu-S1759127AbYAUKB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127AbYAUKB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758411AbYAUKBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:01:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758403AbYAUKBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:01:49 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: [GFS2] Pre-pull patch posting
Date: Mon, 21 Jan 2008 09:21:18 +0000
Message-Id: <1200907336293-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Here is the current GFS2 patch queue. You'll notice that this time
there are no DLM patches in this list. That is because the DLM team
are setting up their own git tree and this future DLM patches will
be sent directly by them rather than via the GFS2 tree.

Most of this set of patches is clean up and bug fixes, there is really
not a lot new this time. I guess the most significant thing is the
patch to use ->page_mkwrite which will greatly increase efficiency
when files opened r/w are mostly only accessed for reading across a
cluster.

There are a number of cleanups related to journalling which is really
where the largest number of changes in terms of code lines is. The
indirect blocks for the journal are now scanned once only at mount
time and the bmap information is retained in the form of an extent
list. Since we expect journals to consist of only a single extent
in the normal case, this should generally be quite a short list :-)

In addition some of the tunables relating to the journal have been
removed in favour of autotuning those variables.

Steve.

