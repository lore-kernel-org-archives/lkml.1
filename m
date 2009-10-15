Return-Path: <linux-kernel-owner+w=401wt.eu-S933333AbZJOVSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333AbZJOVSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 17:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757840AbZJOVSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 17:18:46 -0400
Received: from smtp-out.google.com ([216.239.33.17]:21623 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584AbZJOVSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 17:18:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=daHWjFQAKGgsoo1ETofIAGRiivbS3F2oPs4jkT0zX9SBm0FlSb4V75BBA+nYHHWhj
	mmm+8qP08n1JQMcM6wtCw==
Date: Thu, 15 Oct 2009 14:17:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nitin Gupta <ngupta@vflare.org>, hongshin@gmail.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 7/9] swap_info: swap count continuations
In-Reply-To: <20091015123024.21ca3ef7.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.00.0910151414570.25796@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0910150130001.2250@sister.anvils> <Pine.LNX.4.64.0910150153560.3291@sister.anvils> <20091015123024.21ca3ef7.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, KAMEZAWA Hiroyuki wrote:

> Hmm...maybe I don't understand the benefit of this style of data structure.
> 
> Do we need fine grain chain ? 
> Is  array of "unsigned long" counter is bad ?  (too big?)
> 

I'm wondering if flex_array can be used for this purpose, which can store 
up to 261632 elements of size unsigned long with 4K pages, or whether 
finding the first available bit or weight would be too expensive.
