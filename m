Return-Path: <linux-kernel-owner+w=401wt.eu-S1031645AbXEAKEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031645AbXEAKEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031644AbXEAKEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:04:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031645AbXEAKEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:04:31 -0400
Subject: [DLM] Fix uninitialised variable in receiving [3/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Patrick Caulfield <pcaulfie@redhat.com>
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 10:59:58 +0100
Message-Id: <1178013598.5462.132.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 89adc934f3f96600e7f31447426c7e99d62c5460 Mon Sep 17 00:00:00 2001
From: Patrick Caulfield <pcaulfie@redhat.com>
Date: Tue, 13 Mar 2007 17:08:45 +0000
Subject: [PATCH] [DLM] Fix uninitialised variable in receiving

The length of the second element of the kvec array was not initialised before
being added to the first one. This could cause invalid lengths to be passed to
kernel_recvmsg

Signed-Off-By: Patrick Caulfield <pcaulfie@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lowcomms-tcp.c b/fs/dlm/lowcomms-tcp.c
index 07e0a12..9bfe7fb 100644
--- a/fs/dlm/lowcomms-tcp.c
+++ b/fs/dlm/lowcomms-tcp.c
@@ -299,6 +299,7 @@ static int receive_from_sock(struct connection *con)
 	 */
 	iov[0].iov_len = con->cb.base - cbuf_data(&con->cb);
 	iov[0].iov_base = page_address(con->rx_page) + cbuf_data(&con->cb);
+	iov[1].iov_len = 0;
 	nvec = 1;
 
 	/*
-- 
1.5.1.2



