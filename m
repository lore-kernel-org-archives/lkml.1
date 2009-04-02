Return-Path: <linux-kernel-owner+w=401wt.eu-S932783AbZDBTWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783AbZDBTWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932535AbZDBTWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:22:30 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20408 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932715AbZDBTW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:22:29 -0400
Date: Thu, 2 Apr 2009 21:22:26 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Izik Eidus <ieidus@redhat.com>
cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       avi@redhat.com, aarcange@redhat.com, chrisw@redhat.com, riel@redhat.com,
       jeremy@goop.org, mtosatti@redhat.com, hugh@veritas.com, corbet@lwn.net,
       yaniv@redhat.com, dmonakhov@openvz.org
Subject: Re: [PATCH 0/4] ksm - dynamic page sharing driver for linux
In-Reply-To: <1238457560-7613-1-git-send-email-ieidus@redhat.com>
Message-ID: <alpine.LNX.2.00.0904022114040.4265@swampdragon.chaosbits.net>
References: <1238457560-7613-1-git-send-email-ieidus@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 31 Mar 2009, Izik Eidus wrote:

> KSM is a linux driver that allows dynamicly sharing identical memory
> pages between one or more processes.
> 
> Unlike tradtional page sharing that is made at the allocation of the
> memory, ksm do it dynamicly after the memory was created.
> Memory is periodically scanned; identical pages are identified and
> merged.
> The sharing is unnoticeable by the process that use this memory.
> (the shared pages are marked as readonly, and in case of write
> do_wp_page() take care to create new copy of the page)
> 
> To find identical pages ksm use algorithm that is split into three
> primery levels:
> 
> 1) Ksm will start scan the memory and will calculate checksum for each
>    page that is registred to be scanned.
>    (In the first round of the scanning, ksm would only calculate
>     this checksum for all the pages)
> 

One question;

Calcolating a checksum is a fine way to find pages that are "likely to be 
identical", but there is no guarantee that two pages with the same 
checksum really are identical - there *will* be checksum collisions 
eventually. So, I really hope that your implementation actually checks 
that two pages that it find that have identical checksums really are 100% 
identical by comparing them bit by bit before throwing one away.
If you rely only on a checksum then eventually a user will get bitten by a 
checksum collision and, in the best case, something will crash, and in the 
worst case, data will silently be corrupted.

Do you rely only on the checksum or do you actually compare pages to check 
they are 100% identical before sharing?

I must admit that I have not read through the patch to find the answer, I 
just read your description and became concerned.

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

