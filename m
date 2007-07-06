Return-Path: <linux-kernel-owner+w=401wt.eu-S1763681AbXGFJls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763681AbXGFJls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 05:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763170AbXGFJlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 05:41:36 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:51861 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762875AbXGFJle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 05:41:34 -0400
Message-ID: <468E0E52.2060705@bull.net>
Date: Fri, 06 Jul 2007 11:41:38 +0200
From: Zoltan Menyhart <Zoltan.Menyhart@bull.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.3) Gecko/20040913
X-Accept-Language: en-us, en, fr, hu
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-ia64@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, "tony.luck@intel.com" <tony.luck@intel.com>,
       nickpiggin@yahoo.com.au, mike@stroyan.net, dmosberger@gmail.com,
       GOTO <y-goto@jp.fujitsu.com>
Subject: Re: [BUGFIX]{PATCH] flush icache on ia64 take2
References: <20070706112901.16bb5f8a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070706112901.16bb5f8a.kamezawa.hiroyu@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 06/07/2007 11:45:49,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 06/07/2007 11:45:51,
	Serialize complete at 06/07/2007 11:45:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:

>  Note1: icache flush is called only when VM_EXEC flag is on and 
>         PG_arch_1 is not set.

If you have not got the page in the cache, then the new page will
be allocated with PG_arch_1 bit off.
You are going to flush pages which are read by HW DMA, i.e. the L2I
of Montecito does not keep old lines for those pages anyway.

...->a_ops->readpage() of "L2I safe" file systems should set PG_arch_1
if the CPU is ia64 and it has got separate L2I.

On the other hand, arch. independent file systems should not play with
PG_arch_1.
The base kernel should export a macro for the file systems...

Thanks,

Zoltan Menyhart


