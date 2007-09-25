Return-Path: <linux-kernel-owner+w=401wt.eu-S1754362AbXIYXPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbXIYXPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbXIYXPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:15:06 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:59214 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbXIYXPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:15:05 -0400
To: haveblue@us.ibm.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: missing mnt_drop_write() on open error
Message-Id: <E1IaJc0-000541-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 26 Sep 2007 01:14:40 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I get this at umount, if there was a failed open():

WARNING: at fs/namespace.c:586 __mntput()

I think the problem is that may_open() calls mnt_want_write(), but if
open doesn't succeed, mnt_drop_write() will not be called.

Miklos
