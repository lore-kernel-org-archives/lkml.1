Return-Path: <linux-kernel-owner+w=401wt.eu-S1756944AbXH2BK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbXH2BK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 21:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbXH2BKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 21:10:18 -0400
Received: from expredir5.cites.uiuc.edu ([128.174.5.96]:62682 "EHLO
	expredir5.cites.uiuc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbXH2BKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 21:10:18 -0400
X-Greylist: delayed 717 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Aug 2007 21:10:17 EDT
From: Yoann Padioleau <padator@wanadoo.fr>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: miss list_del(), bug ?
Date: Tue, 28 Aug 2007 19:58:13 +0200
Message-ID: <874pij8rt6.fsf@gmail.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Shouldn't this code also do a list_del(e) ? 

in drivers/infiniband/core/iwcm.c:

static void dealloc_work_entries(struct iwcm_id_private *cm_id_priv)
{
	struct list_head *e, *tmp;

	list_for_each_safe(e, tmp, &cm_id_priv->work_free_list)
		kfree(list_entry(e, struct iwcm_work, free_list));
}

