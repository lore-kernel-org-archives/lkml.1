Return-Path: <linux-kernel-owner+w=401wt.eu-S1752009AbXCEW4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbXCEW4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbXCEW4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:56:32 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52877
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752009AbXCEW4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:56:31 -0500
Date: Mon, 05 Mar 2007 14:56:29 -0800 (PST)
Message-Id: <20070305.145629.28789919.davem@davemloft.net>
To: schwidefsky@de.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       heiko.carstens@de.ibm.com
Subject: Re: [S390] Use generic bug.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070305224354.GN22630@skybase>
References: <20070305224354.GN22630@skybase>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Date: Mon, 5 Mar 2007 23:43:54 +0100

> +	if (__builtin_constant_p(__ret_warn_on)) {	\
> +		if (__ret_warn_on)			\
> +			__EMIT_BUG(BUGFLAG_WARNING);	\

I see we'll have this construct on powerpc, parisc and now s390.

But if it's going to trigger essentially at compile time, I
think it's much better to BUILD_BUG_ON() in this case instead
of counting on the code path to actually run and the user to
notice and report the kernel log message.
