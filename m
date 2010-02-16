Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab0BPHD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 02:03:59 -0500
Received: from smtp-out.google.com ([216.239.44.51]:38732 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932643Ab0BPHD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 02:03:56 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=SLlN0JsL3TTz52SUIO1THR0IptL91535P0hoO+Am/yLwpY8DQnVXFvv/yGepbziO/
	BtIJqFT1xwhYmTrGVBPDw==
Date: Mon, 15 Feb 2010 23:03:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm: add comment about deprecation of __GFP_NOFAIL
In-Reply-To: <20100216102626.5f6f0e11.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1002152300580.2745@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com> <alpine.DEB.2.00.1002151419260.26927@chino.kir.corp.google.com> <20100216085706.c7af93e1.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002151606320.14484@chino.kir.corp.google.com>
 <20100216092147.85ef7619.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1002151712290.23480@chino.kir.corp.google.com> <20100216102626.5f6f0e11.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010, KAMEZAWA Hiroyuki wrote:

> I hope no 3rd vendor (proprietary) driver uses __GFP_NOFAIL, they tend to
> believe API is trustable and unchanged.
> 

I hope they don't use it with GFP_ATOMIC, either, because it's never been 
respected in that context.  We can easily audit the handful of cases in 
the kernel that use __GFP_NOFAIL (it takes five minutes at the max) and 
prove that none use it with GFP_ATOMIC or GFP_NOFS.  We don't need to add 
multitudes of warnings about using a deprecated flag with ludicrous 
combinations (does anyone really expect GFP_ATOMIC | __GFP_NOFAIL to work 
gracefully)?
