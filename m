Return-Path: <linux-kernel-owner+w=401wt.eu-S1750801AbXBSJhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750801AbXBSJhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 04:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbXBSJhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 04:37:33 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:2056 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbXBSJhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 04:37:32 -0500
Message-ID: <45D972CC.2010702@sw.ru>
Date: Mon, 19 Feb 2007 12:50:04 +0300
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, vatsa@in.ibm.com,
       ckrm-tech@lists.sourceforge.net, Balbir Singh <balbir@in.ibm.com>,
       xemul@sw.ru, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       svaidy@linux.vnet.ibm.com, devel@openvz.org
Subject: Re: [ckrm-tech] [RFC][PATCH][0/4] Memory controller (RSS Control)
References: <20070219065019.3626.33947.sendpatchset@balbir-laptop>	<20070219005441.7fa0eccc.akpm@linux-foundation.org> <6599ad830702190106m3f391de4x170326fef2e4872@mail.gmail.com>
In-Reply-To: <6599ad830702190106m3f391de4x170326fef2e4872@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On 2/19/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>>Alas, I fear this might have quite bad worst-case behaviour.  One small
>>container which is under constant memory pressure will churn the
>>system-wide LRUs like mad, and will consume rather a lot of system time.
>>So it's a point at which container A can deleteriously affect things which
>>are running in other containers, which is exactly what we're supposed to
>>not do.
> 
> 
> I think it's OK for a container to consume lots of system time during
> reclaim, as long as we can account that time to the container involved
> (i.e. if it's done during direct reclaim rather than by something like
> kswapd).
hmm, is it ok to scan 100Gb of RAM for 10MB RAM container?
in UBC patch set we used page beancounters to track containter pages.
This allows to make efficient scan contoler and reclamation.

Thanks,
Kirill
