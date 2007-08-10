Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbXHJEuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbXHJEuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 00:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbXHJEuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 00:50:07 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:53825 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbXHJEuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 00:50:05 -0400
Message-ID: <46BBEE6D.1040704@linux.vnet.ibm.com>
Date: Fri, 10 Aug 2007 10:19:49 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       Eric W Biederman <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [-mm PATCH 0/9] Memory controller introduction (v4)
References: <20070727200937.31565.78623.sendpatchset@balbir-laptop> <20070808125139.7cfe702c.kamezawa.hiroyu@jp.fujitsu.com> <20070808165131.b4ab4e92.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070808165131.b4ab4e92.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


KAMEZAWA Hiroyuki wrote:
> On Wed, 8 Aug 2007 12:51:39 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
>> On Sat, 28 Jul 2007 01:39:37 +0530
>> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>> At OLS, the resource management BOF, it was discussed that we need to manage
>>> RSS and unmapped page cache together. This patchset is a step towards that
>>>
>> Can I make a question ? Why limiting RSS instead of # of used pages per
>> container ? Maybe bacause of shared pages between container.... 
> Sorry....Ignore above question.
> I didn't understand what mem_container_charge() accounts and limits.
> It controls # of meta_pages.

Hi Kame,

Actually the number of pages resident in memory brought in by a
container is charged.  However each such page will have a meta_page
allocated to keep the extra data.

Yes, the accounting counts the number of meta_page which is same as
the number of mapped and unmapped (pagecache) pages brought into the
system memory by this container.  Whether pagecache pages should be
included or not is configurable per container through the 'type' file
in containerfs.

--Vaidy

