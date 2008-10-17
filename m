Return-Path: <linux-kernel-owner+w=401wt.eu-S1753027AbYJQGsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbYJQGsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 02:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYJQGsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 02:48:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57003
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751943AbYJQGsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 02:48:11 -0400
Date: Thu, 16 Oct 2008 23:47:47 -0700 (PDT)
Message-Id: <20081016.234747.193703936.davem@davemloft.net>
To: hpa@zytor.com
Cc: benh@kernel.crashing.org, torvalds@linux-foundation.org, rdreier@cisco.com,
       Geert.Uytterhoeven@sonycom.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, yhlu.kernel@gmail.com, akpm@linux-foundation.org
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
From: David Miller <davem@davemloft.net>
In-Reply-To: <48F83316.5080107@zytor.com>
References: <20081016.222108.13382080.davem@davemloft.net>
	<1224225365.7654.88.camel@pasglop>
	<48F83316.5080107@zytor.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 16 Oct 2008 23:39:18 -0700

> Benjamin Herrenschmidt wrote:
> > The latest patch I posted will do full size of resource_size_t unless
> > you arch explicitely adds a #define to do it differently so that
> > should work for you :-)
> > 
> 
> IMNSHO I think you can default to 8 digits for I/O for PCI, since at least last I looked there was no 64-bit address space possible for I/O.

Resources are representing different things on different platforms.

On sparc64 it's actually the full 64-bit physical I/O address on the
system bus being stored in there.  So even IORESOURCE_IO objects have
64-bits of relevancy.

Like I said, printing out the entire thing has helped me find real
bugs, so printing the whole thing is not without merit.
