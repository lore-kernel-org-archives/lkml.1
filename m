Return-Path: <linux-kernel-owner+w=401wt.eu-S1750816AbXBSJys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750816AbXBSJys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 04:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbXBSJys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 04:54:48 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41237 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbXBSJyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 04:54:47 -0500
Date: Mon, 19 Feb 2007 18:48:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       ckrm-tech@lists.sourceforge.net, xemul@sw.ru, linux-mm@kvack.org,
       menage@google.com, svaidy@linux.vnet.ibm.com, balbir@in.ibm.com,
       devel@openvz.org
Subject: Re: [RFC][PATCH][3/4] Add reclaim support
Message-Id: <20070219184839.db9f3bc1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070219065042.3626.95544.sendpatchset@balbir-laptop>
References: <20070219065019.3626.33947.sendpatchset@balbir-laptop>
	<20070219065042.3626.95544.sendpatchset@balbir-laptop>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Feb 2007 12:20:42 +0530
Balbir Singh <balbir@in.ibm.com> wrote:

> +int memctlr_mm_overlimit(struct mm_struct *mm, void *sc_cont)
> +{
> +	struct container *cont;
> +	struct memctlr *mem;
> +	long usage, limit;
> +	int ret = 1;
> +
> +	if (!sc_cont)
> +		goto out;
> +
> +	read_lock(&mm->container_lock);
> +	cont = mm->container;

> +out:
> +	read_unlock(&mm->container_lock);
> +	return ret;
> +}
> +

should be
==
out_and_unlock:
	read_unlock(&mm->container_lock);
out_:
	return ret;


-Kame

