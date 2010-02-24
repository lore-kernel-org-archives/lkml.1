Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab0BXVIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 16:08:20 -0500
Received: from smtp-out.google.com ([216.239.33.17]:30878 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757767Ab0BXVIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 16:08:18 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ER5gbGhjNPmM3p7fHJmABlDasGhA4QrzN+263JHTsyFdHbzZdI45V6yjgKGti1R/G
	J2XvoZj4DDbaFoq25rdNA==
Date: Wed, 24 Feb 2010 13:08:12 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Miao Xie <miaox@cn.fujitsu.com>
cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [regression] cpuset,mm: update tasks' mems_allowed in time
 (58568d2)
In-Reply-To: <4B84F2FD.6030605@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002241307040.30870@chino.kir.corp.google.com>
References: <20100218134921.GF9738@laptop> <alpine.DEB.2.00.1002181302430.13707@chino.kir.corp.google.com> <20100219033126.GI9738@laptop> <alpine.DEB.2.00.1002190143040.6293@chino.kir.corp.google.com> <4B827043.3060305@cn.fujitsu.com>
 <alpine.DEB.2.00.1002221339160.14426@chino.kir.corp.google.com> <4B838490.1050908@cn.fujitsu.com> <alpine.DEB.2.00.1002230046160.12015@chino.kir.corp.google.com> <4B839E9D.8020604@cn.fujitsu.com> <alpine.DEB.2.00.1002231427190.8693@chino.kir.corp.google.com>
 <4B84F2FD.6030605@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Feb 2010, Miao Xie wrote:

> I think it is not a big deal because it is safe and doesn't cause any problem.
> Beside that, task->cpus_allowed is initialized to cpu_possible_mask on the no-cpuset
> kernel, so using cpu_possible_mask to initialize task->cpus_allowed is reasonable.
> (top cpuset is a special cpuset, isn't it?)
>  

I'm suprised that I can create a descendant cpuset of top_cpuset that 
cannot include all of its parents' cpus and that the root cpuset's cpus 
mask doesn't change when cpus are onlined/offlined.
