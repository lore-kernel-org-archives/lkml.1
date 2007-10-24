Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbXJXRNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbXJXRNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbXJXRNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:13:35 -0400
Received: from smtp-out.google.com ([216.239.33.17]:39416 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbXJXRNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:13:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=hXwYeWxp+r4qpVrh2PPEo0klBwksEz7SsaaXGUW03hwJQIr+KPwVXdBLdXMP6cPWH
	+ElNdtfOj4qOdEUKkIYmg==
Message-ID: <6599ad830710241013s4a85984er3cebd2ba471baf62@mail.gmail.com>
Date: Wed, 24 Oct 2007 10:13:26 -0700
From: "Paul Menage" <menage@google.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] kernel/cgroup.c: remove dead code
Cc: "Paul Jackson" <pj@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071024170701.GB30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071024162534.GZ30533@stusta.de>
	 <6599ad830710240930r6649dec0q21b8c00f7d8a796a@mail.gmail.com>
	 <20071024170701.GB30533@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/07, Adrian Bunk <bunk@kernel.org> wrote:
>
> Two questions:
> - Is it really intended to perhaps change release_agent_path[] to have
>   less than PATH_MAX size?

I've got no intention to do so currently.

> - If yes, do you want to return -E2BIG for (nbytes >= PATH_MAX) or for
>   (nbytes >= sizeof(root->release_agent_path)) ?

I think E2BIG for the former for backwards compatabilty; the latter
could be either ENOSPC or E2BIG; i.e. both checks are useful - one to
stop us allocating more memory than is sensible, and one to stop us
overrunning the buffer; the fact that these two are the same size at
the moment is coincidence.

I guess ideally the first check would be for the max() of any of the
data structures that we expect to be able to write over; PATH_MAX was
just picked as a convenience.

Paul
