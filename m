Return-Path: <linux-kernel-owner+w=401wt.eu-S936028AbXG3Oay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936028AbXG3Oay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 10:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbXG3Oaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 10:30:46 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:38660 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbXG3Oap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 10:30:45 -0400
Message-ID: <46ADF61A.6000509@bull.net>
Date: Mon, 30 Jul 2007 16:30:50 +0200
From: Zoltan Menyhart <Zoltan.Menyhart@bull.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.3) Gecko/20040913
X-Accept-Language: en-us, en, fr, hu
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "tony.luck@intel.com" <tony.luck@intel.com>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] flush icache before set_pte() take 5.
References: <20070728150319.d19f531f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070728150319.d19f531f.kamezawa.hiroyu@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 30/07/2007 16:35:29,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 30/07/2007 16:35:30,
	Serialize complete at 30/07/2007 16:35:30
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:

> Considerations:
>   - I can add CONFIG_MONTECITO if necessary. But it will be confusing, I think.

What about this trick below?

identify_cpu() finds out the "c->family".
If any of the CPUs has c->family==32 (and the future versions...) then
set a global flag. And:

static inline void sync_icache_dcache(pte_t pte) {
        if (pte_exec(pte) && global_flag)
                __sync_icache_dcache(pte);
}

Thanks,

Zoltan
