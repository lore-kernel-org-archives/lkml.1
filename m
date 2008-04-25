Return-Path: <linux-kernel-owner+w=401wt.eu-S932387AbYDYUat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387AbYDYUat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 16:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762343AbYDYUad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 16:30:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54469
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760643AbYDYUaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 16:30:30 -0400
Date: Fri, 25 Apr 2008 13:30:30 -0700 (PDT)
Message-Id: <20080425.133030.229754755.davem@davemloft.net>
To: jengelh@computergmbh.de
Cc: hpa@zytor.com, torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 01/24] types: create <asm-generic/int-*.h>
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.1.10.0804252026040.20150@fbirervta.pbzchgretzou.qr>
References: <1209078352-7593-2-git-send-email-hpa@zytor.com>
	<1209078352-7593-3-git-send-email-hpa@zytor.com>
	<alpine.LNX.1.10.0804252026040.20150@fbirervta.pbzchgretzou.qr>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@computergmbh.de>
Date: Fri, 25 Apr 2008 20:27:53 +0200 (CEST)

> On Friday 2008-04-25 01:05, H. Peter Anvin wrote:
> 
> >This creates two generic files with common integer definitions; one
> >where 64 bits is "long" (most 64-bit architectures) and one where 64
> >bits is "long long" (all 32-bit architectures and x86-64.)
> 
> long long is 64 bits on both 32 and 64, is not it?
> If so, the split between 32 and 64 should not be necessary.

Because of the large precendence, if you change this stuff, you're
going to get tons of warnings on the platforms that use "unsigned
long" currently if you change them to use "unsigned long long".

Think about all of the implicit type conversions, argument passing,
et al.

I know because I tried to convert sparc64 over to "unsigned long long"
to make it more like powerpc, and I found quickly that fixing up all
the fallout simply was not worth it.
