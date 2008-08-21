Return-Path: <linux-kernel-owner+w=401wt.eu-S1756997AbYHUDJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997AbYHUDJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 23:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756622AbYHUDI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 23:08:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57069
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756599AbYHUDIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 23:08:53 -0400
Date: Wed, 20 Aug 2008 20:08:52 -0700 (PDT)
Message-Id: <20080820.200852.193706487.davem@davemloft.net>
To: holt@sgi.com
Cc: cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, tokunaga.keiich@jp.fujitsu.com
Subject: Re: [RFC][PATCH 0/2] Quicklist is slighly problematic.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080821021332.GA23397@sgi.com>
References: <20080820195021.12E7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<48AC25E7.4090005@linux-foundation.org>
	<20080821021332.GA23397@sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Holt <holt@sgi.com>
Date: Wed, 20 Aug 2008 21:13:32 -0500

> One problem I see is somebody got rid of the node awareness.  We used
> to not put pages onto a quicklist when they were being released from a
> different node than the cpu is on.  Not sure where that went.  It was
> done because of the trap page problem described here.

NUMA awareness is one of the reasons I keep thinking about dropping
quicklist usage on sparc64.

Using SLAB/SLUB for the page table bits with appropriate constructor
and destructor bits ought to be able to approximate the gains
from avoiding the initialization for cached objects.
