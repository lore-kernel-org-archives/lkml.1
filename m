Return-Path: <linux-kernel-owner+w=401wt.eu-S1030202AbXCFSrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030202AbXCFSrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:47:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966008AbXCFSre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:47:34 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45063
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S966004AbXCFSrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:47:32 -0500
Date: Tue, 06 Mar 2007 10:47:29 -0800 (PST)
Message-Id: <20070306.104729.43502575.davem@davemloft.net>
To: heiko.carstens@de.ibm.com
Cc: schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: Re: [S390] Use generic bug.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070306115917.GA28321@osiris.boeblingen.de.ibm.com>
References: <20070305224354.GN22630@skybase>
	<20070305.145629.28789919.davem@davemloft.net>
	<20070306115917.GA28321@osiris.boeblingen.de.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Tue, 6 Mar 2007 12:59:17 +0100

> On Mon, Mar 05, 2007 at 02:56:29PM -0800, David Miller wrote:
> > From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > Date: Mon, 5 Mar 2007 23:43:54 +0100
> > 
> > > +	if (__builtin_constant_p(__ret_warn_on)) {	\
> > > +		if (__ret_warn_on)			\
> > > +			__EMIT_BUG(BUGFLAG_WARNING);	\
> > 
> > I see we'll have this construct on powerpc, parisc and now s390.
> > 
> > But if it's going to trigger essentially at compile time, I
> > think it's much better to BUILD_BUG_ON() in this case instead
> > of counting on the code path to actually run and the user to
> > notice and report the kernel log message.
> 
> So something like WARN_ON(1) won't compile, but BUG_ON(1) still
> would? Seems odd to me.
> Also since there is nothing like WARN(), you have to use WARN_ON(1).
> Btw.: sparc64 has plenty of these ;)

I see.  It's for case where we can't put the test into the
WARN_ON() call.

Thanks for the explanation, I hadn't considered such cases.
