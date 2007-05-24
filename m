Return-Path: <linux-kernel-owner+w=401wt.eu-S1750956AbXEXNsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750956AbXEXNsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 09:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750696AbXEXNsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 09:48:09 -0400
Received: from il.qumranet.com ([82.166.9.18]:56369 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750700AbXEXNsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 09:48:08 -0400
Message-ID: <46559794.50208@qumranet.com>
Date: Thu, 24 May 2007 16:48:04 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       shaohua.li@intel.com, lhcs-devel@lists.sourceforge.net
Subject: Re: [PATCH 4/7] SMP: Implement on_one_cpu()
References: <1180008615579-git-send-email-avi@qumranet.com>	<11800086152009-git-send-email-avi@qumranet.com> <adaejl68hh7.fsf@cisco.com>
In-Reply-To: <adaejl68hh7.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> I don't see any documented restrictions about preemption being
> disabled when this function is called, but...
>
>  > +int on_one_cpu(int cpu, void (*func) (void *info), void *info,
>  > +	       int retry, int wait)
>  > +{
>  > +	int ret;
>  > +	int this_cpu;
>  > +
>  > +	this_cpu = get_cpu();
>
> what if a preempt and reschedule to a different CPU happens right
> here, after this_cpu is set?
>
>  > +	if (this_cpu == cpu) {
>   

get_cpu() disables preemption (the return value would be meaningless 
otherwise).


-- 
error compiling committee.c: too many arguments to function

