Return-Path: <linux-kernel-owner+w=401wt.eu-S1764625AbXHOIpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764625AbXHOIpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 04:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755276AbXHOIo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 04:44:57 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:60318 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756106AbXHOIoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 04:44:55 -0400
To: svaidy@linux.vnet.ibm.com
Cc: a.p.zijlstra@chello.nl, dhaval@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, ebiederm@xmission.com,
       containers@lists.osdl.org, akpm@linux-foundation.org, xemul@openvz.org,
       menage@google.com, balbir@linux.vnet.ibm.com
Subject: Re: [-mm PATCH 4/9] Memory controller memory accounting (v4)
In-Reply-To: Your message of "Tue, 31 Jul 2007 18:14:26 +0530"
	<46AF2EAA.2080703@linux.vnet.ibm.com>
References: <46AF2EAA.2080703@linux.vnet.ibm.com>
X-Mailer: Cue version 0.8 (070404-1613/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20070815084454.09B061BF982@siro.lan>
Date: Wed, 15 Aug 2007 17:44:53 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> YAMAMOTO Takashi wrote:
> >> +	lock_meta_page(page);
> >> +	/*
> >> +	 * Check if somebody else beat us to allocating the meta_page
> >> +	 */
> >> +	race_mp = page_get_meta_page(page);
> >> +	if (race_mp) {
> >> +		kfree(mp);
> >> +		mp = race_mp;
> >> +		atomic_inc(&mp->ref_cnt);
> >> +		res_counter_uncharge(&mem->res, 1);
> >> +		goto done;
> >> +	}
> > 
> > i think you need css_put here.
> 
> Thats correct. We do need css_put in this path.
> 
> Thanks,
> Vaidy

v5 still seems to have the problem.

YAMAMOTO Takashi
