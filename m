Return-Path: <linux-kernel-owner+w=401wt.eu-S932969AbXCUQbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969AbXCUQbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 12:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932987AbXCUQbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 12:31:51 -0400
Received: from smtp.osdl.org ([65.172.181.24]:42841 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932969AbXCUQbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 12:31:50 -0400
Date: Wed, 21 Mar 2007 08:30:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Jarek Poplawski" <jarkao2@o2.pl>,
       "Eric Dumazet" <dada1@cosmosbay.com>, mpm@selenic.com,
       "Christoph Lameter" <clameter@sgi.com>, "ast@domdv.de" <ast@domdv.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
Message-Id: <20070321083027.437361f1.akpm@linux-foundation.org>
In-Reply-To: <84144f020703210741g4b6b2000kf19b439a4c42f445@mail.gmail.com>
References: <Pine.LNX.4.64.0703200943430.3622@sbz-30.cs.Helsinki.FI>
	<20070321133151.GC1939@ff.dom.local>
	<Pine.LNX.4.64.0703211531450.16596@sbz-30.cs.Helsinki.FI>
	<200703211511.10342.rjw@sisk.pl>
	<84144f020703210741g4b6b2000kf19b439a4c42f445@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007 16:41:19 +0200 "Pekka Enberg" <penberg@cs.helsinki.fi> wrote:

> On 3/21/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > IMHO one way to find them is to actually slow down kmem_cache_free() and see
> > where the performance is hurt.
> 
> Yeah, I'll try to sneak a patch past Andrew.

That would be sneaky.

Thing is, such a patch would amount to adding a test-for-NULL to codepaths
which we *know* do not need it.  There is no point in doing that.
