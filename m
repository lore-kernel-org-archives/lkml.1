Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbYDWWJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbYDWWJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 18:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbYDWWJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 18:09:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:47965 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbYDWWJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 18:09:33 -0400
In-Reply-To: <480F8754.7000200@tiscali.nl>
References: <480F6905.3070808@tiscali.nl> <480F8754.7000200@tiscali.nl>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <df21920e067e73985f73047e2d8bcbda@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org,
       lkml <linux-kernel@vger.kernel.org>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 2/2] mpic_u3msi: mpic_u3msi: failed allocation unnoticed
Date: Thu, 24 Apr 2008 00:09:21 +0200
To: Roel Kluin <12o3l@tiscali.nl>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> bitmap_find_free_region(), called by mpic_msi_alloc_hwirqs() may
> return -ENOMEM, but hwirq of type irq_hw_number_t which is unsigned.

>  	list_for_each_entry(entry, &pdev->msi_list, list) {
>  		hwirq = mpic_msi_alloc_hwirqs(msi_mpic, 1);
> -		if (hwirq < 0) {
> +		if (hwirq == -ENOMEM) {
>  			pr_debug("u3msi: failed allocating hwirq\n");
>  			return hwirq;
>  		}

Please test for _all_ error values, instead.


Segher

