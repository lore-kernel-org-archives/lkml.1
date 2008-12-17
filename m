Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760113AbYLQH40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760113AbYLQH40 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 02:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYLQH4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 02:56:16 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44626 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbYLQH4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 02:56:16 -0500
Date: Wed, 17 Dec 2008 07:56:12 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/15] don't reallocate buffer in every audit_sockaddr()
Message-ID: <20081217075612.GY28946@ZenIV.linux.org.uk>
References: <E1LCogg-00008b-SH@ZenIV.linux.org.uk> <20081216234927.9cb8a077.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216234927.9cb8a077.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 11:49:27PM -0800, Andrew Morton wrote:
> > +	if (!context->sockaddr) {
> > +		void *p = kmalloc(sizeof(struct sockaddr_storage), GFP_KERNEL);
> 
> argh, I really hate having to run all around the code verifying that
> the type passed to sizeof matches the type that we'll be storing there :(

And I really hate being unable to find the places doing such allocations
without serious parsing.  Matter of taste.
 
> stoopid question: can an audit_contect be shared between
> threads/processes?  If so, is locking needed around the read/test/write
> of context->sockaddr and friends?  

It can't.  And that's very fortunate, since otherwise all that crap would
	a) be horribly racy
	b) require shitloads of locking all over the place, driving the
overhead even higher.
