Return-Path: <linux-kernel-owner+w=401wt.eu-S1758703AbYAUIIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703AbYAUIIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 03:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757867AbYAUIIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 03:08:16 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44884
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757863AbYAUIIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 03:08:15 -0500
Date: Mon, 21 Jan 2008 00:08:20 -0800 (PST)
Message-Id: <20080121.000820.194841023.davem@davemloft.net>
To: travis@sgi.com
Cc: akpm@linux-foundation.org, ak@suse.de, mingo@elte.hu, clameter@sgi.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCH 1/7] Modules: Fold percpu_modcopy into module.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080118182953.922370000@sgi.com>
References: <20080118182953.748071000@sgi.com>
	<20080118182953.922370000@sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: travis@sgi.com
Date: Fri, 18 Jan 2008 10:29:54 -0800

> percpu_modcopy() is defined multiple times in arch files. However, the only
> user is module.c. Put a static definition into module.c and remove
> the definitions from the arch files.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Andi Kleen <ak@suse.de>
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> Signed-off-by: Mike Travis <travis@sgi.com>

This doesn't build on sparc64.

The percpu_modcopy() removal from include/asm-sparc64/percpu.h
leaked into patch #3 instead of being done here in patch #1
where it belongs (so that this series is properly bisectable).

It also seems that the include/asm-x86/percpu_{32,64}.h defines
aren't removed in this patch either.
