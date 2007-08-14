Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbXHNIfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbXHNIfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 04:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbXHNIfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 04:35:32 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:33638 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbXHNIf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 04:35:29 -0400
Message-ID: <46C1691E.7090708@ah.jp.nec.com>
Date: Tue, 14 Aug 2007 17:34:38 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: vgoyal@in.ibm.com
CC: Keith Owens <kaos@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       k-miyoshi@cb.jp.nec.com, Bernhard Walle <bwalle@suse.de>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] add kdump_after_notifier
References: <20070802112852.GA7054@in.ibm.com> <31687.1186113947@kao2.melbourne.sgi.com> <20070805110746.GA12540@in.ibm.com>
In-Reply-To: <20070805110746.GA12540@in.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Fri, Aug 03, 2007 at 02:05:47PM +1000, Keith Owens wrote:
> 
> 
> To sum up, couple of options come to mind.
> 
> - Register all the RAS tools on die notifier and panic
>   notifier lists with fairly high priority. Export list
>   of RAS tools to user space and allow users to decide the
>   order of execution and priority of RAS tools.
> 
> - Create a separate RAS tool notifier list (ras_tool_notifer_list).
>   All the RAS tools register on this list. This list gets priority
>   over die or panic notifier list. User decides the oder of execution
>   of RAS tools. 
> 
>   Here assumption is that above list will not be exported to modules.
>   All the RAS tools will be in kernel and they always get a priority
>   to inspect an event.
> 
> What do others think?

Very good idea. But there is a problem how to give default priority to RAS tools.

How about priority changeable notifier_list? User can change list order
dynamically if they want. Of course, we have to give highest priority to kdump
by default. It is very useful for users who want to use some RAS tools.
