Return-Path: <linux-kernel-owner+w=401wt.eu-S1753564AbYLIKbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbYLIKbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 05:31:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYLIKa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 05:30:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43130 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbYLIKa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 05:30:56 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081208232418.GJ19417@fieldses.org>
References: <20081208232418.GJ19417@fieldses.org> <alpine.LFD.2.00.0812050848060.3386@nehalem.linux-foundation.org> <20081205162318.20732.73054.stgit@warthog.procyon.org.uk> <23235.1228502954@redhat.com> <alpine.LFD.2.00.0812051053190.3386@nehalem.linux-foundation.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, hugh@veritas.com,
       hch@infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] EXPORTFS: handle NULL returns from fh_to_dentry()/fh_to_parent()
Date: Tue, 09 Dec 2008 10:30:11 +0000
Message-ID: <30673.1228818611@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields <bfields@fieldses.org> wrote:

> +	if (!result)
> +		result = ERR_PTR(-ESTALE);
>  	if (IS_ERR(result))
>  		return result;

This is why I think this is a bad idea.  This adds an extra conditional test
and branch.  In fact, the way you've done it means you have to do the extra
branch whatever[*]; it might be better to have the if-statement you added
return directly.

[*] assuming gcc doesn't manage to be clever enough to omit the second test if
    the first is true.

David
