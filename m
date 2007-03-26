Return-Path: <linux-kernel-owner+w=401wt.eu-S1752135AbXCZLp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbXCZLp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 07:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbXCZLp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 07:45:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbXCZLp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 07:45:26 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0703261427490.12793@sbz-30.cs.Helsinki.FI> 
References: <Pine.LNX.4.64.0703261427490.12793@sbz-30.cs.Helsinki.FI>  <20070326024143.a226c9b2.akpm@linux-foundation.org> <1174904637.32691.86.camel@roc-desktop> <6017.1174908318@redhat.com> 
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, bryan.wu@analog.com,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       dhowells@redhat.com
Subject: Re: [PATCH -mm] Revoke core code: fix nommu arch compiling error bug 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Mon, 26 Mar 2007 12:44:19 +0100
Message-ID: <6791.1174909459@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> But what's more important is, can we do revoke_mapping() for NOMMU? AFAICT 
> we can, we just need to scan all the global vmas, right?

I don't know, what does it do?  Remember, once a NOMMU process thinks it has
the right to access a mapping, there's no way of stopping it doing so short of
killing the process.

With NOMMU as it stands, private mappings are private copies of the data, and
have no impact on the page cache and get no updates from it.  It's as if you
took a private writable mapping, touched every page and then mprotect()'d it.
This isn't necessarily ideal, but we're limited by the lack on an MMU.

David
