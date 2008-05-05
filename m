Return-Path: <linux-kernel-owner+w=401wt.eu-S1763214AbYEEWRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763214AbYEEWRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 18:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbYEEWRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 18:17:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754298AbYEEWRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 18:17:14 -0400
Date: Mon, 5 May 2008 15:11:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, skumar@linux.vnet.ibm.com, yamamoto@valinux.co.jp,
       menage@google.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       rientjes@google.com, xemul@openvz.org, balbir@linux.vnet.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [-mm][PATCH 1/4] Setup the rlimit controller
Message-Id: <20080505151142.f52b9d9e.akpm@linux-foundation.org>
In-Reply-To: <20080503213736.3140.83278.sendpatchset@localhost.localdomain>
References: <20080503213726.3140.68845.sendpatchset@localhost.localdomain>
	<20080503213736.3140.83278.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 May 2008 03:07:36 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> +	*tmp = ((*tmp + PAGE_SIZE) >> PAGE_SHIFT) << PAGE_SHIFT;

Whatever this is doing, it should not be doing it this way ;)

perhaps

	*tmp = ALIGN(*tmp, PAGE_SIZE);

or even

	*tmp = PAGE_ALIGN(*tmp);

?


<looks at PAGE_ALIGN>

Each architecture implements its own version and they of course do it
differently.  It's crying out for a consolidated implementation but we have
no include/linux/page.h into which to consolidate it.

