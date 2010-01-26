Return-Path: <linux-kernel-owner+w=401wt.eu-S1753046Ab0AZXQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab0AZXQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976Ab0AZXQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:16:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752590Ab0AZXQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:16:26 -0500
Date: Tue, 26 Jan 2010 15:16:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, rientjes@google.com,
       minchan.kim@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] oom-kill: add lowmem usage aware oom kill handling
Message-Id: <20100126151606.54764be2.akpm@linux-foundation.org>
In-Reply-To: <20100125151503.49060e74.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com>
	<20100122152332.750f50d9.kamezawa.hiroyu@jp.fujitsu.com>
	<20100125151503.49060e74.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jan 2010 15:15:03 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> -unsigned long badness(struct task_struct *p, unsigned long uptime)
> +unsigned long badness(struct task_struct *p, unsigned long uptime,
> +			int constraint)

And badness() should be renamed to something better (eg, oom_badness), and
the declaration should be placed in a mm-specific header file.

Yes, the code was already like that.  But please don't leave crappiness in
place when you come across it - take the opportunity to fix it up.
