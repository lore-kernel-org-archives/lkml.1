Return-Path: <linux-kernel-owner+w=401wt.eu-S1750837AbXBSKZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750837AbXBSKZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 05:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbXBSKZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 05:25:27 -0500
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:37141 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbXBSKZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 05:25:24 -0500
Message-ID: <45D97AC7.2000903@in.ibm.com>
Date: Mon, 19 Feb 2007 15:54:07 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Kirill Korotaev <dev@sw.ru>
CC: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       vatsa@in.ibm.com, ckrm-tech@lists.sourceforge.net, xemul@sw.ru,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       svaidy@linux.vnet.ibm.com, devel@openvz.org
Subject: Re: [ckrm-tech] [RFC][PATCH][0/4] Memory controller (RSS Control)
References: <20070219065019.3626.33947.sendpatchset@balbir-laptop>	<20070219005441.7fa0eccc.akpm@linux-foundation.org> <6599ad830702190106m3f391de4x170326fef2e4872@mail.gmail.com> <45D972CC.2010702@sw.ru>
In-Reply-To: <45D972CC.2010702@sw.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill Korotaev wrote:
>> On 2/19/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>>> Alas, I fear this might have quite bad worst-case behaviour.  One small
>>> container which is under constant memory pressure will churn the
>>> system-wide LRUs like mad, and will consume rather a lot of system time.
>>> So it's a point at which container A can deleteriously affect things which
>>> are running in other containers, which is exactly what we're supposed to
>>> not do.
>>
>> I think it's OK for a container to consume lots of system time during
>> reclaim, as long as we can account that time to the container involved
>> (i.e. if it's done during direct reclaim rather than by something like
>> kswapd).
> hmm, is it ok to scan 100Gb of RAM for 10MB RAM container?
> in UBC patch set we used page beancounters to track containter pages.
> This allows to make efficient scan contoler and reclamation.
> 
> Thanks,
> Kirill

Hi, Kirill,

Yes, that's a problem, but I think it's a problem that can be solved
in steps. First step, add reclaim. Second step, optimize reclaim.

-- 
	Warm Regards,
	Balbir Singh
