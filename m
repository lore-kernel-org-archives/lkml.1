Return-Path: <linux-kernel-owner+w=401wt.eu-S933238AbXCFMA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238AbXCFMA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 07:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933233AbXCFMA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 07:00:59 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:11036 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932488AbXCFMA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 07:00:57 -0500
Date: Tue, 6 Mar 2007 12:59:17 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: Re: [S390] Use generic bug.
Message-ID: <20070306115917.GA28321@osiris.boeblingen.de.ibm.com>
References: <20070305224354.GN22630@skybase> <20070305.145629.28789919.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305.145629.28789919.davem@davemloft.net>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 02:56:29PM -0800, David Miller wrote:
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Date: Mon, 5 Mar 2007 23:43:54 +0100
> 
> > +	if (__builtin_constant_p(__ret_warn_on)) {	\
> > +		if (__ret_warn_on)			\
> > +			__EMIT_BUG(BUGFLAG_WARNING);	\
> 
> I see we'll have this construct on powerpc, parisc and now s390.
> 
> But if it's going to trigger essentially at compile time, I
> think it's much better to BUILD_BUG_ON() in this case instead
> of counting on the code path to actually run and the user to
> notice and report the kernel log message.

So something like WARN_ON(1) won't compile, but BUG_ON(1) still
would? Seems odd to me.
Also since there is nothing like WARN(), you have to use WARN_ON(1).
Btw.: sparc64 has plenty of these ;)

I would prefer to have something like a per arch defined WARN()
and a common code WARN_ON() like we have it already for BUG_ON().
Then I would agree: if WARN_ON() is used with a constant the build
should fail. Just to tell the author that he did something wrong
or simply should use WARN(). And of course the existing BUG_ON()
could be converted as well.
