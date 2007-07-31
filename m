Return-Path: <linux-kernel-owner+w=401wt.eu-S939995AbXGaDin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939995AbXGaDin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 23:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759426AbXGaDif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 23:38:35 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:39459 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752387AbXGaDie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 23:38:34 -0400
To: balbir@linux.vnet.ibm.com
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, ebiederm@xmission.com, containers@lists.osdl.org,
       menage@google.com, xemul@openvz.org
Subject: Re: [-mm PATCH 4/9] Memory controller memory accounting (v4)
In-Reply-To: Your message of "Sat, 28 Jul 2007 01:40:18 +0530"
	<20070727201018.31565.42132.sendpatchset@balbir-laptop>
References: <20070727201018.31565.42132.sendpatchset@balbir-laptop>
X-Mailer: Cue version 0.8 (070404-1613/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20070731033832.9E8B41BF6B4@siro.lan>
Date: Tue, 31 Jul 2007 12:38:32 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +	lock_meta_page(page);
> +	/*
> +	 * Check if somebody else beat us to allocating the meta_page
> +	 */
> +	race_mp = page_get_meta_page(page);
> +	if (race_mp) {
> +		kfree(mp);
> +		mp = race_mp;
> +		atomic_inc(&mp->ref_cnt);
> +		res_counter_uncharge(&mem->res, 1);
> +		goto done;
> +	}

i think you need css_put here.

YAMAMOTO Takashi
