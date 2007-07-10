Return-Path: <linux-kernel-owner+w=401wt.eu-S1761863AbXGJToi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761863AbXGJToi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 15:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbXGJToa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 15:44:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44543 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755134AbXGJTo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 15:44:29 -0400
Date: Tue, 10 Jul 2007 12:44:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: avoiding rejects
Message-Id: <20070710124422.a52b0458.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


There are many situations where patching the kernel involves adding a new
item to a list, such as:

- adding a makefile line
- adding a new #include
- adding a new Kconfig entry
- adding a new PCI ID
- adding a record to feature-removal.txt
- adding a new sysctl table entry
- etc

Of course, everyone just sticks the new entry at the end of the existing
entries.  This strategy carefully maximises the opportunity for patch
rejects and leads to unhappiness.

Most of these lists are unordered anyway, so inserting the new item at a
randomly-chosen position is a better approach than just appending it.
