Return-Path: <linux-kernel-owner+w=401wt.eu-S936057AbXGSPTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936057AbXGSPTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935648AbXGSPS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:18:57 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:38859 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934570AbXGSPSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:18:55 -0400
Message-ID: <469F80E3.3040007@bull.net>
Date: Thu, 19 Jul 2007 17:18:59 +0200
From: Zoltan Menyhart <Zoltan.Menyhart@bull.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.3) Gecko/20040913
X-Accept-Language: en-us, en, fr, hu
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, tony.luck@intel.com, nickpiggin@yahoo.com.au,
       mike@stroyan.net, dmosberger@gmail.com, y-goto@jp.fujitsu.com
Subject: Re: [BUGFIX]{PATCH] flush icache on ia64 take2
References: <20070706112901.16bb5f8a.kamezawa.hiroyu@jp.fujitsu.com>	<20070719155632.7dbfb110.kamezawa.hiroyu@jp.fujitsu.com>	<469F5372.7010703@bull.net>	<20070719220118.73f40346.kamezawa.hiroyu@jp.fujitsu.com>	<469F71E7.4050200@bull.net> <20070719235157.9715baff.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070719235157.9715baff.kamezawa.hiroyu@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 19/07/2007 17:23:25,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 19/07/2007 17:23:27,
	Serialize complete at 19/07/2007 17:23:27
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:

> Hmm...but the current code flushes the page. just do it in "lazy" way.
> much difference ?

I agree the current code flushes the I-cache for all kinds of file
systems (for PTEs with the exec bit on).

The error is that it does it after the PTE is written.

In addition, I wanted to optimize it to gain a few %.
Apparently this idea is not much welcome.

I can agree that flushing the I-cache (if the architecture requires it)
before setting the PTE eliminates the error.

Thanks,

Zoltan
