Return-Path: <linux-kernel-owner+w=401wt.eu-S1758097AbYCTVNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbYCTVNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 17:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbYCTVMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 17:12:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60828
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754982AbYCTVMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 17:12:51 -0400
Date: Thu, 20 Mar 2008 14:13:07 -0700 (PDT)
Message-Id: <20080320.141307.173590705.davem@davemloft.net>
To: johannes@sipsolutions.net
Cc: sam@ravnborg.org, dsd@gentoo.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH/RFC v2] introduce ARCH_CAN_UNALIGNED_ACCESS Kconfig
 symbol
From: David Miller <davem@davemloft.net>
In-Reply-To: <1206038373.16475.150.camel@johannes.berg>
References: <1206023695.16475.137.camel@johannes.berg>
	<20080320181310.GA17884@uranus.ravnborg.org>
	<1206038373.16475.150.camel@johannes.berg>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 20 Mar 2008 19:39:33 +0100

> In many cases, especially in networking, it can be beneficial to
> know at compile time whether the architecture can do unaligned
> accesses. This patch introduces a new Kconfig symbol
> 	ARCH_CAN_UNALIGNED_ACCESS
> for that purpose and adds it to the powerpc and x86 architectures.
> Also add some documentation about alignment and networking, and
> especially one intended use of this symbol.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

I think you're semantically testing the wrong thing.

It's not if unaligned accesses are supported, it's if they are
efficient enough or not.

For example, sparc64 fully handles unaligned accesses but taking the
trap to fix it up is slow.  So sparc64 "can" handle unaligned
accesses, but whether we want to set this symbol or not is another
matter.
