Return-Path: <linux-kernel-owner+w=401wt.eu-S938748AbXFHRpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938748AbXFHRpN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 13:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936025AbXFHRo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 13:44:58 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:52041 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936936AbXFHRo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 13:44:57 -0400
Message-ID: <46699584.2020905@linux.vnet.ibm.com>
Date: Fri, 08 Jun 2007 23:14:36 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Pavel Emelianov <xemul@openvz.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH 0/8] RSS controller based on process containers (v3.1)
References: <466412C5.1060104@openvz.org> <20070608120343.GA27847@MAIL.13thfloor.at> <46694E00.8020407@openvz.org> <20070608153700.GB27847@MAIL.13thfloor.at>
In-Reply-To: <20070608153700.GB27847@MAIL.13thfloor.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Herbert Poetzl wrote:
> On Fri, Jun 08, 2007 at 04:39:28PM +0400, Pavel Emelianov wrote:
>> Herbert Poetzl wrote:
>>> On Mon, Jun 04, 2007 at 05:25:25PM +0400, Pavel Emelianov wrote:
[snip]
>>>> When this usage exceeds the limit set some pages are reclaimed
>>>> from the owning container. In case no reclamation possible the OOM
>>>> killer starts thinning out the container.
>>> so the system (physical machine) starts reclaiming
>>> and probably swapping even when there is no need
>>> to do so?
>> Good catch! The system will start reclaiming right when the
>> container hits the limit to expend its IO bandwidth. Not some
>> other's one that hit the global limit due to some bad container
>> was allowed to go above it.
> 
> well, from the system PoV, a constantly swapping
> guest (on an otherwise unused host) is definitely
> something you do not really want, not to talk
> about a tightly packed host system, where guests
> start hogging the I/O with _unnecessary_ swapping
> 
>>> e.g. a system with a single guest, limited to 10k
>>> pages, with a working set of 15k pages in different
>>> apps would continuously swap (trash?) on an otherwise
>>> unused (100k+ pages) system?
>>>

Hi Herbert,

When the reclaim process started, swappable pages are unmapped and
moved to swapcache.  The RSS accounting treats the page as dropped,
but however the page will remain in memory until there is enough
global pressure to push it out to disk.  When a page is faulted-in,
the page is just remapped from the swapcache.

In effect container 'trashing' is not as bad in an otherwise unused
system.  Well, certainly we pay a penalty to move around the pages
instead of keeping them mapped in RSS as long as free memory was
available.

The pagecache controller is suppose to track the pagecache and
swapcache pages and push out pages to disk. As Balbir and Pavel have
mentioned, we will be building the features in stages.

--Vaidy

[snip]

