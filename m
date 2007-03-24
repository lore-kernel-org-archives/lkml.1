Return-Path: <linux-kernel-owner+w=401wt.eu-S2992651AbXCXBB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992651AbXCXBB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 21:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992652AbXCXBB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 21:01:57 -0400
Received: from smtp-out.google.com ([216.239.45.13]:15854 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992651AbXCXBB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 21:01:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=CR4btezyS9TjcYaoZ0V4NFjWnFjfIQraXrwqPk+c3azlVr98hpBZwSPqHn2yJC+Cl
	wo75sV9q//Nq3rfrG7krQ==
Message-ID: <b040c32a0703231801h9a44344s2d0e0649b8ca4c4b@mail.gmail.com>
Date: Fri, 23 Mar 2007 18:01:49 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Christoph Hellwig" <hch@infradead.org>, "Ken Chen" <kenchen@google.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] cache pipe buf page address for non-highmem arch
In-Reply-To: <20070323101452.GA15144@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b040c32a0703221751x54417524l5237742f345eeda9@mail.gmail.com>
	 <20070323101452.GA15144@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/23/07, Christoph Hellwig <hch@infradead.org> wrote:
> I think you're fixing the symptom here and not the cause.  If calculating
> the virtual address of a page is so expensive on your setup it should
> define WANT_PAGE_VIRTUAL and we should always cache the virtual address
> in struct page.  There's a lot more code, epecially in filesystems that's
> rather upset about a slow page_address.

Adding WANT_PAGE_VIRTUAL would be too costly I think as it will expand
the sizeof struct page.  I would rather go incremental fix on these
issues and not blindly increase page struct size.
