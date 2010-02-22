Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab0BVWBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 17:01:05 -0500
Received: from smtp-out.google.com ([216.239.33.17]:35619 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab0BVWBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 17:01:01 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Oc2EWr5/chBb3jnOYnb6MOdp2+W6QDB/ApgfCl7ev5qTl0Yq8piX7tUKDwnPjnV3u
	IW+eU/W9ylXnSUhrhxfcw==
Date: Mon, 22 Feb 2010 14:00:52 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nick Piggin <npiggin@suse.de>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Miao Xie <miaox@cn.fujitsu.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [regression] cpuset,mm: update tasks' mems_allowed in time
 (58568d2)
In-Reply-To: <20100222121222.GV9738@laptop>
Message-ID: <alpine.DEB.2.00.1002221400060.23881@chino.kir.corp.google.com>
References: <20100218134921.GF9738@laptop> <alpine.DEB.2.00.1002181302430.13707@chino.kir.corp.google.com> <20100219033126.GI9738@laptop> <alpine.DEB.2.00.1002190143040.6293@chino.kir.corp.google.com> <20100222121222.GV9738@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Feb 2010, Nick Piggin wrote:

> If you have a concurrent reader without any synchronisation, then what
> stops it from loading a word of the mask before stores to add the new
> nodes and then loading another word of the mask after the stores to
> remove the old nodes? (which can give an empty mask).
> 

Currently nothing, so we'll need a variant for configurations where the 
size of nodemask_t is larger than we can atomically store.
