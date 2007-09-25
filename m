Return-Path: <linux-kernel-owner+w=401wt.eu-S1752950AbXIYW1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbXIYW1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 18:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbXIYW1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 18:27:38 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:44724 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbXIYW1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 18:27:37 -0400
To: greg@kroah.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: subsystem_unregister() breakage in -mm
Message-Id: <E1IaIs6-00051t-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 26 Sep 2007 00:27:14 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I get "BUG: failure at mm/slab.c:591/page_get_cache()!" in latest -mm
when removing the fuse module.

This patch titled "kobject: remove the static array for the name"
looks like it's responsible.  Reverting it cures the problem.

The root of the problem seems to be, that decl_subsys() initializes
k_name with a string constant.  Then subsystem_unregister() will put
the kobject, which will free the k_name.

So, what's the right way to deal with this?

Thanks,
Miklos
