Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbYDHC4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbYDHC4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 22:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbYDHC4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 22:56:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241AbYDHC4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 22:56:23 -0400
Date: Mon, 7 Apr 2008 19:55:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: balbir@linux.vnet.ibm.com
Cc: menage@google.com, xemul@openvz.org, hugh@veritas.com,
       skumar@linux.vnet.ibm.com, yamamoto@valinux.co.jp, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [-mm] Add an owner to the mm_struct (v8)
Message-Id: <20080407195549.beca617e.akpm@linux-foundation.org>
In-Reply-To: <47FADAFD.7030202@linux.vnet.ibm.com>
References: <20080404080544.26313.38199.sendpatchset@localhost.localdomain>
	<20080407150956.9a29573a.akpm@linux-foundation.org>
	<47FADAFD.7030202@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Apr 2008 08:09:57 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Andrew Morton wrote:
> > On Fri, 04 Apr 2008 13:35:44 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> >> 1. Add mm->owner change callbacks using cgroups
> >>
> >> ...
> >>
> >> +config MM_OWNER
> >> +	bool "Enable ownership of mm structure"
> >> +	help
> >> +	  This option enables mm_struct's to have an owner. The advantage
> >> +	  of this approach is that it allows for several independent memory
> >> +	  based cgroup controllers to co-exist independently without too
> >> +	  much space overhead
> >> +
> >> +	  This feature adds fork/exit overhead. So enable this only if
> >> +	  you need resource controllers
> > 
> > Do we really want to offer this option to people?  It's rather a low-level
> > thing and it's likely to cause more confusion than it's worth.  Remember
> > that most kernels get to our users via kernel vendors - to what will they
> > be setting this config option?
> > 
> 
> I suspect that this kernel option will not be explicitly set it. This option
> will be selected by other config options (memory controller, swap namespace,
> revoke*)

I believe that the way to do this is to not give the option a `help'
section.  Tht makes it a Kconfig-internal-only thing.

