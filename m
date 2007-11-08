Return-Path: <linux-kernel-owner+w=401wt.eu-S1761970AbXKHUnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761970AbXKHUnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 15:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759541AbXKHUn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 15:43:28 -0500
Received: from smtp-out.google.com ([216.239.45.13]:59218 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbXKHUn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 15:43:27 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=EqMwHSImvuAiSrBNGhd2DZYKgKe7dA3z55OugqwPE2710A2vnMzrm5yHhQ8vniqC7
	IakTZKHm0EwfNCJFnm8mA==
Message-ID: <b040c32a0711081243gd51acb0m3049ced25411524f@mail.gmail.com>
Date: Thu, 8 Nov 2007 12:43:20 -0800
From: "Ken Chen" <kenchen@google.com>
To: "Adam Litke" <agl@us.ibm.com>
Subject: Re: [PATCH] hugetlb: follow_hugetlb_page for write access
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       "Hoang-Nam Nguyen" <hnguyen@linux.vnet.ibm.com>
In-Reply-To: <20071107195142.13505.49398.stgit@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071107195142.13505.49398.stgit@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 7, 2007 11:51 AM, Adam Litke <agl@us.ibm.com> wrote:
> When calling get_user_pages(), a write flag is passed in by the caller to
> indicate if write access is required on the faulted-in pages.  Currently,
> follow_hugetlb_page() ignores this flag and always faults pages for
> read-only access.  This can cause data corruption because a device driver
> that calls get_user_pages() with write set will not expect COW faults to
> occur on the returned pages.
>
> This patch passes the write flag down to follow_hugetlb_page() and makes
> sure hugetlb_fault() is called with the right write_access parameter.
>
> Signed-off-by: Adam Litke <agl@us.ibm.com>

Adam, this looks good.

Reviewed-by: Ken Chen <kenchen@google.com>
