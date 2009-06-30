Return-Path: <linux-kernel-owner+w=401wt.eu-S1760448AbZF3ADX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760448AbZF3ADX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 20:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760327AbZF3ADA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 20:03:00 -0400
Received: from smtp-out.google.com ([216.239.33.17]:38014 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760421AbZF3AC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 20:02:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=sbO7VdCnzz2uiGN1tuiqO8ZlmyHh+0XV22etLY5DX3nkXunIZjr33G/1+/ydFhiCt
	+bPs8PoU+N1BiFVMtYaRA==
Date: Mon, 29 Jun 2009 17:02:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rik van Riel <riel@redhat.com>
Subject: Re: [Bug #13648] nfsd: page allocation failure
In-Reply-To: <5Hhc7UkUKEO.A.KGF.HjASKB@chimera>
Message-ID: <alpine.DEB.2.00.0906291659550.17663@chino.kir.corp.google.com>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera> <5Hhc7UkUKEO.A.KGF.HjASKB@chimera>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13648
> Subject		: nfsd: page allocation failure
> Submitter	: Justin Piszcz <jpiszcz@lucidpixels.com>
> Date		: 2009-06-22 12:08 (7 days old)
> References	: http://lkml.org/lkml/2009/6/22/309
> 

I'd be interested to hear from Justin if reducing 
/proc/sys/vm/dirty_background_ratio as I earlier suggested helps.  

ZONE_NORMAL isn't much larger than ZONE_DMA32 on this machine and both 
lowmem zones have an abundance of free memory which suggests pdflush's 
ratio isn't being met to commence background writeout while at the same 
time ZONE_NORMAL is being depleted as the result of constant nfs 
GFP_ATOMIC allocations that cannot try direct reclaim.
