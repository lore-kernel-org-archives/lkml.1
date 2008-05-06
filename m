Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbYEFDl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbYEFDl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 23:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbYEFDlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 23:41:46 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:39276 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbYEFDlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 23:41:46 -0400
Message-ID: <481FD342.2040707@linux.vnet.ibm.com>
Date: Tue, 06 May 2008 09:10:50 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, skumar@linux.vnet.ibm.com, yamamoto@valinux.co.jp,
       menage@google.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       rientjes@google.com, xemul@openvz.org, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [-mm][PATCH 1/4] Setup the rlimit controller
References: <20080503213726.3140.68845.sendpatchset@localhost.localdomain> <20080503213736.3140.83278.sendpatchset@localhost.localdomain> <20080505151142.f52b9d9e.akpm@linux-foundation.org>
In-Reply-To: <20080505151142.f52b9d9e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sun, 04 May 2008 03:07:36 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> +	*tmp = ((*tmp + PAGE_SIZE) >> PAGE_SHIFT) << PAGE_SHIFT;
> 
> Whatever this is doing, it should not be doing it this way ;)
> 
> perhaps
> 
> 	*tmp = ALIGN(*tmp, PAGE_SIZE);
> 
> or even
> 
> 	*tmp = PAGE_ALIGN(*tmp);
> 
> ?
> 

Good point, thanks for catching this.

> 
> <looks at PAGE_ALIGN>
> 
> Each architecture implements its own version and they of course do it
> differently.  It's crying out for a consolidated implementation but we have
> no include/linux/page.h into which to consolidate it.

May be we can move this to asm-generic/page.h?


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
