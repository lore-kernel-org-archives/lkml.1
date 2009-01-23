Return-Path: <linux-kernel-owner+w=401wt.eu-S1757408AbZAWDWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbZAWDWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 22:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbZAWDWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 22:22:13 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45697 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbZAWDWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 22:22:12 -0500
Date: Fri, 23 Jan 2009 12:21:38 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] get_mm_hiwater_xxx: trivial, s/define/inline/
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20090118033953.GA23666@redhat.com>
References: <20090118033953.GA23666@redhat.com>
Message-Id: <20090123204419.34D0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -#define get_mm_hiwater_rss(mm)	max((mm)->hiwater_rss, get_mm_rss(mm))
> -#define get_mm_hiwater_vm(mm)	max((mm)->hiwater_vm, (mm)->total_vm)
> +static inline unsigned long get_mm_hiwater_rss(struct mm_struct *mm)
> +{
> +	return max(mm->hiwater_rss, get_mm_rss(mm));
> +}
> +
> +static inline unsigned long get_mm_hiwater_vm(struct mm_struct *mm)
> +{
> +	return max(mm->hiwater_vm, mm->total_vm);
> +}

looks good to me.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



