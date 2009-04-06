Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbZDFJOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbZDFJOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755001AbZDFJN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:13:59 -0400
Received: from ports.donpac.ru ([80.254.111.81]:36629 "EHLO ports.donpac.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878AbZDFJN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:13:58 -0400
Date: Mon, 6 Apr 2009 13:13:48 +0400
From: Andrey Panin <pazke@donpac.ru>
To: Izik Eidus <ieidus@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, linux-mm@kvack.org, avi@redhat.com,
       aarcange@redhat.com, chrisw@redhat.com, mtosatti@redhat.com,
       hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 4/4] add ksm kernel shared memory driver.
Message-ID: <20090406091348.GA18464@ports.donpac.ru>
Mail-Followup-To: Izik Eidus <ieidus@redhat.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-mm@kvack.org, avi@redhat.com, aarcange@redhat.com,
	chrisw@redhat.com, mtosatti@redhat.com, hugh@veritas.com,
	kamezawa.hiroyu@jp.fujitsu.com
References: <1238855722-32606-1-git-send-email-ieidus@redhat.com> <1238855722-32606-2-git-send-email-ieidus@redhat.com> <1238855722-32606-3-git-send-email-ieidus@redhat.com> <1238855722-32606-4-git-send-email-ieidus@redhat.com> <1238855722-32606-5-git-send-email-ieidus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238855722-32606-5-git-send-email-ieidus@redhat.com>
X-Uname: Linux 2.6.18-4-powerpc64 ppc64
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 094, 04 04, 2009 at 05:35:22PM +0300, Izik Eidus wrote:

<SNIP>

> +static inline u32 calc_checksum(struct page *page)
> +{
> +	u32 checksum;
> +	void *addr = kmap_atomic(page, KM_USER0);
> +	checksum = jhash(addr, PAGE_SIZE, 17);

Why jhash2() is not used here ? It's faster and leads to smaller code size.

> +	kunmap_atomic(addr, KM_USER0);
> +	return checksum;
> +}

