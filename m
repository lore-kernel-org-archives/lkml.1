Return-Path: <linux-kernel-owner+w=401wt.eu-S933275AbXCKMMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275AbXCKMMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 08:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933276AbXCKMMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 08:12:42 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:1617 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933275AbXCKMMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 08:12:41 -0400
Message-ID: <45F3F581.9030503@sw.ru>
Date: Sun, 11 Mar 2007 15:26:41 +0300
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Pavel Emelianov <xemul@sw.ru>, Paul Menage <menage@google.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       devel@openvz.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       containers@lists.osdl.org
Subject: Re: [RFC][PATCH 2/7] RSS controller core
References: <45ED7DEC.7010403@sw.ru>	<45ED80E1.7030406@sw.ru> <20070306140036.4e85bd2f.akpm@linux-foundation.org>
In-Reply-To: <20070306140036.4e85bd2f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 06 Mar 2007 17:55:29 +0300
> Pavel Emelianov <xemul@sw.ru> wrote:
> 
> 
>>+struct rss_container {
>>+	struct res_counter res;
>>+	struct list_head page_list;
>>+	struct container_subsys_state css;
>>+};
>>+
>>+struct page_container {
>>+	struct page *page;
>>+	struct rss_container *cnt;
>>+	struct list_head list;
>>+};
> 
> 
> ah.  This looks good.  I'll find a hunk of time to go through this work
> and through Paul's patches.  It'd be good to get both patchsets lined
> up in -mm within a couple of weeks.  But..
> 
> We need to decide whether we want to do per-container memory limitation via
> these data structures, or whether we do it via a physical scan of some
> software zone, possibly based on Mel's patches.
i.e. a separate memzone for each container?
imho memzone approach is inconvinient for pages sharing and shares accounting.
it also makes memory management more strict, forbids overcommiting
per-container etc.
Maybe you have some ideas how we can decide on this?

Thanks,
Kirill

