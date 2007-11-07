Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbXKGDBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbXKGDBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 22:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbXKGDAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 22:00:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398AbXKGDAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 22:00:51 -0500
Date: Tue, 6 Nov 2007 22:00:45 -0500
From: Rik van Riel <riel@redhat.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 6/10] split anon and file LRUs
Message-ID: <20071106220045.2a8a189f@bree.surriel.com>
In-Reply-To: <Pine.LNX.4.64.0711061825590.5249@schroedinger.engr.sgi.com>
References: <20071103184229.3f20e2f0@bree.surriel.com>
	<20071103190158.34b4650e@bree.surriel.com>
	<Pine.LNX.4.64.0711061825590.5249@schroedinger.engr.sgi.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2007 18:28:19 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:
> On Sat, 3 Nov 2007, Rik van Riel wrote:
> 
> > Split the LRU lists in two, one set for pages that are backed by
> > real file systems ("file") and one for pages that are backed by
> > memory and swap ("anon").  The latter includes tmpfs.
> 
> If we split the memory backed from the disk backed pages then
> they are no longer competing with one another on equal terms? So the file LRU 
> may run faster than the memory LRU?

The file LRU probably *should* run faster than the memory LRU most
of the time, since we stream the readahead data for many sequentially
accessed files through the file LRU.

We adjust the rates at which the two LRUs are scanned depending on
the fraction of referenced pages found when scanning each list.
Look at vmscan.c:get_scan_ratio() for the magic.

> The patch looks awfully large.

Making it smaller would probably result in something that does
not work right.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
