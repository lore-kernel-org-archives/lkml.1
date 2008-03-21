Return-Path: <linux-kernel-owner+w=401wt.eu-S1755608AbYCUHZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbYCUHZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 03:25:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbYCUHYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 03:24:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47053
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753389AbYCUHYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 03:24:53 -0400
Date: Fri, 21 Mar 2008 00:25:02 -0700 (PDT)
Message-Id: <20080321.002502.223136918.davem@davemloft.net>
To: clameter@sgi.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [11/14] vcompound: Fallbacks for order 1 stack allocations on
 IA64 and x86
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080321061726.782068299@sgi.com>
References: <20080321061703.921169367@sgi.com>
	<20080321061726.782068299@sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Thu, 20 Mar 2008 23:17:14 -0700

> This allows fallback for order 1 stack allocations. In the fallback
> scenario the stacks will be virtually mapped.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>

I would be very careful with this especially on IA64.

If the TLB miss or other low-level trap handler depends upon being
able to dereference thread info, task struct, or kernel stack stuff
without causing a fault outside of the linear PAGE_OFFSET area, this
patch will cause problems.

It will be difficult to debug the kinds of crashes this will cause
too.
