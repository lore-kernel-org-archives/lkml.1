Return-Path: <linux-kernel-owner+w=401wt.eu-S1161648AbXDXFpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161648AbXDXFpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 01:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161651AbXDXFpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 01:45:31 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39679 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161648AbXDXFp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 01:45:29 -0400
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
	<m1abwyv4oq.fsf@ebiederm.dsl.xmission.com>
	<1177390842.14873.94.camel@localhost.localdomain>
Date: Mon, 23 Apr 2007 23:43:55 -0600
In-Reply-To: <1177390842.14873.94.camel@localhost.localdomain> (Benjamin
	Herrenschmidt's message of "Tue, 24 Apr 2007 15:00:42 +1000")
Message-ID: <m1zm4ytjhg.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

>> Further in general it doesn't make sense to grab a module reference
>> and call that sufficient because we would like to request that the
>> module exits.
>
> Which is, btw, I think a total misdesign of our module stuff, but heh, I
> remember that lead to some flamewars back then...
>
> Like anything else, modules should have separated the entrypoints for
>
>  - Initiating a removal request
>  - Releasing the module
>
> The former is use did "rmmod", can unregister things from subsystems,
> etc... (and can file if the driver decides to refuse removal requests
> when it's busy doing things or whatever policy that module wants to
> implement).
>
> The later is called when all references to the modules have been
> dropped, it's a bit like the kref "release" (and could be implemented as
> one).
>
> If we had done that (simple) thing back then, module refcounting would
> have been much less of a problem... I remember some reasons why that was
> veto'ed but I didn't and still don't agree.

The basic point is because a thread can terminate sooner if we have an
explicit request to stop, we need that in the design.

Because we need to find the threads to request that they stop we need to
have some way to track them.

Since we need to have some way to track them having an explicit data
structure that the callers manage seems to make sense.

Eric
