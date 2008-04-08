Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbYDHLST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbYDHLST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbYDHLSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:18:12 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:15862 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbYDHLSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:18:11 -0400
Subject: [PATCH 0/29] proc entries creation race
From: "Denis V. Lunev" <den@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: OpenVz kernel team
Date: Tue, 08 Apr 2008 15:18:28 +0400
Message-Id: <1207653508.7171.18.camel@iris.sw.ru>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches fixes an proc ->open'less usage due to ->proc_fops
flip in the most part of the kernel code. The original OOPS is described
in the commit 2d3a4e3666325a9709cc8ea2e88151394e8f20fc.

In addition to this, proc_create_data is introduced to fix reading from
proc without PDE->data. The race is basically the same as above.

create_proc_entries is replaced in the entire kernel code as new method
is also simply better.

Signed-off-by: Denis V. Lunev <den@openvz.org>

