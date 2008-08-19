Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbYHSIoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbYHSIoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 04:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbYHSInw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 04:43:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45406
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754024AbYHSInv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 04:43:51 -0400
Date: Tue, 19 Aug 2008 01:43:50 -0700 (PDT)
Message-Id: <20080819.014350.79505195.davem@davemloft.net>
To: harvey.harrison@gmail.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/23] sparc: use the new byteorder headers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1219106897.17033.71.camel@brick>
References: <1219106897.17033.71.camel@brick>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Mon, 18 Aug 2008 17:48:17 -0700

> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

I'm not so sure about this.

If I understand the ___swab*() inlines in linux/swab.h,
it has the following priority of swapping methods:

1) If arch defines __arch_swab*(), this is used.

2) If arch defines __arch_swab*p(), variable is popped onto
   the stack and we do the pointer based operation.

3) Else normal C version is used.

Case #2 is totally disagree with.

Especially for small swaps such as 16-bit the inline expansion
of the portable C code is going to be much better than popping
the variable onto and then back off the stack.

Sparc 64-bit only provides the __arch_swab*p() routines so
#2 is what will in fact be used here.

So NACK based upon that analysis.
