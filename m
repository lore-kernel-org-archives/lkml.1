Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbYDBQa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbYDBQa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbYDBQau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:30:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755888AbYDBQat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:30:49 -0400
Date: Wed, 2 Apr 2008 09:30:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       sparclinux@vger.kernel.org
Subject: Re: 2.6.25-rc8-mm1 sparc64 build problem: size of array 'type name'
 is negative
Message-Id: <20080402093036.5dfdf56f.akpm@linux-foundation.org>
In-Reply-To: <200804021820.13260.m.kozlowski@tuxland.pl>
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
	<200804021820.13260.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008 18:20:13 +0200 Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Hello,
> 
> 	sparc64 box, gcc 4.1.2
> 
>   CC      arch/sparc64/mm/init.o
> arch/sparc64/mm/init.c: In function 'paging_init':
> arch/sparc64/mm/init.c:1303: error: size of array 'type name' is negative
> 
> and this is 
> 
> BUILD_BUG_ON(BITS_PER_LONG - NR_PAGEFLAGS != 32);

yup, thanks.  That's due to some page-flag rework in the memory management
queue.  The patches which broke mips as well.  I'm pushing cross-compilers
in Christoph's direction and hoping stuff gets fixed...
