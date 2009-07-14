Return-Path: <linux-kernel-owner+w=401wt.eu-S1752427AbZGNMPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbZGNMPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 08:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbZGNMPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 08:15:47 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:41573 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbZGNMPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 08:15:47 -0400
Date: Tue, 14 Jul 2009 14:15:42 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Olaf Weber <olaf@sgi.com>
Cc: felixb@sgi.com, xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] fs/xfs: Drop unnecessary NULL test
In-Reply-To: <bzy7hybzh6k.fsf@fransum.emea.sgi.com>
Message-ID: <Pine.LNX.4.64.0907141412550.456@ask.diku.dk>
References: <Pine.LNX.4.64.0907131209250.6808@ask.diku.dk>
 <bzy7hybzh6k.fsf@fransum.emea.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jul 2009, Olaf Weber wrote:

> Julia Lawall writes:
> 
> > From: Julia Lawall <julia@diku.dk>
> > The result of container_of should not be NULL.  In particular, in this case
> > the argument to the enclosing function has passed though INIT_DELAYED_WORK,
> > which dereferences it, implying that its container cannot be NULL.
> 
> Given the defn of container_of() it seems clear that neither its input
> pointer nor its result should ever be NULL.

container_of just does pointer arithmetic.  The result of that arithmetic 
can be NULL, ie if the argument was obtained from an expression of the 
form &x->f where x was NULL.  But in principle, values should be checked 
for NULL beforehand.

julia
