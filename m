Return-Path: <linux-kernel-owner+w=401wt.eu-S1759460AbZD0VEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460AbZD0VEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 17:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZD0VEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 17:04:09 -0400
Received: from smtp-out.google.com ([216.239.45.13]:49068 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbZD0VEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 17:04:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=mmbApO+PHgC2yc+M+NVHrujqSjb70fggEiTGuinccYbXWdqfiiU7qt7msU2Jl2U8/
	Wkn/t7zQ3v+iIz53kBJvQ==
Date: Mon, 27 Apr 2009 14:04:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Replace the watermark-related union in struct zone with
 a watermark[] array
In-Reply-To: <20090427205400.GA23510@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.0904271400450.11972@chino.kir.corp.google.com>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie> <1240408407-21848-19-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.0904221251350.14558@chino.kir.corp.google.com> <20090427170054.GE912@csn.ul.ie> <alpine.DEB.2.00.0904271340320.11972@chino.kir.corp.google.com>
 <20090427205400.GA23510@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009, Mel Gorman wrote:

> > I thought the suggestion was for something like
> > 
> > 	#define zone_wmark_min(z)	(z->pages_mark[WMARK_MIN])
> > 	...
> 
> Was it the only suggestion? I thought just replacing the union with an
> array would be an option as well.
> 
> The #define approach also requires setter versions like
> 
> static inline set_zone_wmark_min(struct zone *z, unsigned long val)
> {
> 	z->pages_mark[WMARK_MIN] = val;
> }
> 
> and you need one of those for each watermark if you are to avoid weirdness like
> 
> zone_wmark_min(z) = val;
> 
> which looks all wrong.

Agreed, but we only set watermarks in a couple of different locations and 
they really have no reason to change otherwise, so I don't think it's 
necessary to care too much about how the setter looks.

Adding individual get/set functions for each watermark seems like 
overkill.

I personally had no problem with the union struct aliasing the array, I 
think ->pages_min, ->pages_low, etc. are already very familiar.
