Return-Path: <linux-kernel-owner+w=401wt.eu-S1161559AbXDXDWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161559AbXDXDWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 23:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161556AbXDXDWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 23:22:24 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53375 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161548AbXDXDWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 23:22:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linas Vepstas <linas@austin.ibm.com>,
       Christoph Hellwig <hch@infradead.org>, "<Andrew Morton" <akpm@osdl.org>,
       containers@lists.osdl.org, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       linux-s390@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] powerpc pseries eeh: Convert to kthread API
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<11769695763104-git-send-email-ebiederm@xmission.com>
	<20070422123155.GF20763@infradead.org>
	<20070423205020.GR31947@austin.ibm.com>
	<1177378733.14873.52.camel@localhost.localdomain>
	<m1ejmav80l.fsf@ebiederm.dsl.xmission.com>
	<1177382544.14873.57.camel@localhost.localdomain>
Date: Mon, 23 Apr 2007 21:20:37 -0600
In-Reply-To: <1177382544.14873.57.camel@localhost.localdomain> (Benjamin
	Herrenschmidt's message of "Tue, 24 Apr 2007 12:42:24 +1000")
Message-ID: <m1abwyv4oq.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> Not sure... I can see places where I might want to spawn an arbitrary
> number of these without having to preallocate structures... and if I
> allocate on the fly, then I need a way to free that structure when the
> kthread is reaped which I don't think we have currently, do we ? (In
> fact, I could use that for other things too now that I'm thinking of
> it ... I might have a go at providing optional kthread destructors).

Well the basic problem is that for any piece of code that can be modular
we need a way to ensure all threads it has running are shutdown when we
remove the module.

Which means a fire and forget model however simple is unfortunately
the wrong thing.

Now we might be able to wrap this in some kind of manager construct,
so you don't have to manage each thread individually, but we still
have the problem of ensuring all of the threads exit when we terminate
the module.

Further in general it doesn't make sense to grab a module reference
and call that sufficient because we would like to request that the
module exits.

Eric
