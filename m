Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbXD0LRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbXD0LRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 07:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755633AbXD0LRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 07:17:13 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:38867 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbXD0LRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 07:17:11 -0400
Message-ID: <4631DBB2.6090202@linux.vnet.ibm.com>
Date: Fri, 27 Apr 2007 16:47:06 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Pavel Emelianov <xemul@sw.ru>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] RSS container, fix freeing of active pages
References: <4630F6D2.8040407@linux.vnet.ibm.com> <4631C69E.5020307@sw.ru>
In-Reply-To: <4631C69E.5020307@sw.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelianov wrote:

> Hm... Did you see such a situation in your experiments?

Yes, we did. We saw a bad_page() error on the console. A page
was freed with the active bit set.

> If yes, then why not fix it in a normal way by moving the 
> pages from list to list where appropriate?
> 

If we add the pages to the appropriate list at the time of page_add_*rmap(),
we would end up with too many code changes split
all over the place. In many cases when we add a page (install_page()
for example), we just release any existing mapping. We would not know
where to add the page -- active list or inactive list?

I am not sure if that was your question in the first place :-)


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
