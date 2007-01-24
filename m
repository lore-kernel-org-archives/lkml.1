Return-Path: <linux-kernel-owner+w=401wt.eu-S933175AbXAXG6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175AbXAXG6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 01:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933174AbXAXG6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 01:58:00 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54863 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933171AbXAXG57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 01:57:59 -0500
Date: Tue, 23 Jan 2007 22:57:47 -0800
From: Andrew Morton <akpm@osdl.org>
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 002 of 4] md: Make 'repair' actually work for raid1.
Message-Id: <20070123225747.caa15292.akpm@osdl.org>
In-Reply-To: <1070123002652.29462@suse.de>
References: <20070123112437.29357.patches@notabene>
	<1070123002652.29462@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jan 2007 11:26:52 +1100
NeilBrown <neilb@suse.de> wrote:

> +					for (j = 0; j < vcnt ; j++)
> +						memcpy(page_address(sbio->bi_io_vec[j].bv_page),
> +						       page_address(pbio->bi_io_vec[j].bv_page),
> +						       PAGE_SIZE);

I trust these BIOs are known to only contain suitably-allocated, MD-private
pages?  Because if these pages can be user pages then this change is
spectacularly buggy ;)

