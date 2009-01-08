Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbZAHAiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbZAHAiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 19:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZAHAiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 19:38:07 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57625 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbZAHAiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 19:38:06 -0500
Date: Thu, 8 Jan 2009 09:37:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [RFC][PATCH 0/4] Memory controller soft limit patches
Message-Id: <20090108093700.2ad10d85.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090107185627.GL4145@linux.vnet.ibm.com>
References: <20090107184110.18062.41459.sendpatchset@localhost.localdomain>
	<20090107185627.GL4145@linux.vnet.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2009 00:26:27 +0530
Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:

> On Thu, Jan 08, 2009 at 12:11:10AM +0530, Balbir Singh wrote:
> > 
> > Here is v1 of the new soft limit implementation. Soft limits is a new feature
> > for the memory resource controller, something similar has existed in the
> > group scheduler in the form of shares. We'll compare shares and soft limits
> > below. I've had soft limit implementations earlier, but I've discarded those
> > approaches in favour of this one.
> > 
> > Soft limits are the most useful feature to have for environments where
> > the administrator wants to overcommit the system, such that only on memory
> > contention do the limits become active. The current soft limits implementation
> > provides a soft_limit_in_bytes interface for the memory controller and not
> > for memory+swap controller. The implementation maintains an RB-Tree of groups
> > that exceed their soft limit and starts reclaiming from the group that
> > exceeds this limit by the maximum amount.
> > 
> > This is an RFC implementation and is not meant for inclusion
> > 
> > TODOs
> > 
> > 1. The shares interface is not yet implemented, the current soft limit
> >    implementation is not yet hierarchy aware. The end goal is to add
> >    a shares interface on top of soft limits and to maintain shares in
> >    a manner similar to the group scheduler
> 
> Just to clarify, when there is no contention, you want to share memory
> proportionally?
> 
I don't like to add "share" as the kernel interface of memcg.
We used "bytes" to do (hard) limit. Please just use "bytes".

Thanks,
-Kame

