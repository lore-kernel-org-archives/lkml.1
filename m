Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbYE1LvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbYE1LvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 07:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYE1LvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 07:51:05 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:59485 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbYE1Lup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 07:50:45 -0400
Message-ID: <483D46CE.2020507@linux.vnet.ibm.com>
Date: Wed, 28 May 2008 17:19:34 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm 00/16] VM pageout scalability improvements (V8)
References: <20080523195506.084894989@redhat.com> <483B0077.7000207@linux.vnet.ibm.com> <20080526153318.29edc0b2@bree.surriel.com>
In-Reply-To: <20080526153318.29edc0b2@bree.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> On Mon, 26 May 2008 23:54:55 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> Rik van Riel wrote:
>>> On large memory systems, the VM can spend way too much time scanning
>>> through pages that it cannot (or should not) evict from memory. Not
>>> only does it use up CPU time, but it also provokes lock contention
>>> and can leave large systems under memory presure in a catatonic state.
>> Hi, Rik,
>>
>> This patchset looks good (I did a brief scan). I'll go ahead and play with it?
>> What is a good memory size to test the patches on (to see improvements).
> 
> The larger, the better.  One known problem with the current upstream
> VM is large numbers of anonymous pages, or a mix of mlocked and anon
> pages.
> 
> Once the system needs to swap something out, every single anon page
> will have the referenced bit set and the system needs to do lots of
> scanning before it can evict the first page.  This scanning causes
> multiple CPUs to pile up and things slow down exponentially and/or
> catastrophically :)
> 
> Unfortunately the largest system I have access to on a regular basis
> has "only" 16GB of RAM :(
> 
> I am also making 2.6.25 based kernel RPMs available with the split LRU
> patch set, at http://people.redhat.com/riel/splitvm/
> 
> The most recently posted patches are newer, though...
> 

Rik,

I've run into a case where with the splitvm patches the memory controller
immediately OOMs a task in the cgroup on exceeding it's limit. I am going to try
and find the root cause for it.



-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
