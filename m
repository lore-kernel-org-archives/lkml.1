Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbZJANIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbZJANIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 09:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755974AbZJANIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 09:08:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755718AbZJANIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 09:08:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1254384558-1018-11-git-send-email-tj@kernel.org>
References: <1254384558-1018-11-git-send-email-tj@kernel.org> <1254384558-1018-1-git-send-email-tj@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: dhowells@redhat.com, jeff@garzik.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       arjan@linux.intel.com
Subject: Re: [PATCH 10/19] workqueue: update cwq alignement and make one more flag bit available
Date: Thu, 01 Oct 2009 14:05:20 +0100
Message-ID: <10133.1254402320@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:

> +enum {
> +	WORK_STRUCT_PENDING	= 0,	/* work item is pending execution */
> +
> +	/*
> +	 * Reserve 3bits off of cwq pointer.  This is enough and
> +	 * provides acceptable alignment on both 32 and 64bit
> +	 * machines.
> +	 */
> +	WORK_STRUCT_FLAG_BITS	= 3,
> +
> +	WORK_STRUCT_FLAG_MASK	= (1UL << WORK_STRUCT_FLAG_BITS) - 1,
> +	WORK_STRUCT_WQ_DATA_MASK = ~WORK_STRUCT_FLAG_MASK,
> +};

There's some great enum abuse going on here:-)

David
