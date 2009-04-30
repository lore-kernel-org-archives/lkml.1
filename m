Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbZD3W6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbZD3W6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 18:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbZD3W60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 18:58:26 -0400
Received: from smtp-out.google.com ([216.239.45.13]:23049 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbZD3W60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 18:58:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=RMzVdALZ6Qudm2juvSOWJxjHxcy6DuyDTE+/FvrRT/8a+g0D5Elbh0CO3IkawAF48
	/dA8c70XJlGFyqJWgfX4A==
Date: Thu, 30 Apr 2009 15:58:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: npiggin@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch] oom: prevent livelock when oom_kill_allocating_task is
 set
In-Reply-To: <20090430154920.64c9c866.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0904301558020.13061@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0904301538270.12627@chino.kir.corp.google.com> <20090430154920.64c9c866.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009, Andrew Morton wrote:

> > When /proc/sys/vm/oom_kill_allocating_task is set for large systems that
> > want to avoid the lengthy tasklist scan, it's possible to livelock if
> > current is ineligible for oom kill.  This normally happens when it is set
> > to OOM_DISABLE, but is also possible if any threads are sharing the same
> > ->mm with a different tgid.
> 
> OK...  And how does the patch address this problem?
> 
> <reads the code>
> 
> Seems that if we were unable to kill `current', we'll ignore the
> oom_kill_allocating_task setting and will fall back the slow tasklist
> scan?
> 

Yes, sorry.  The annotated changelog you have added to -mm is correct, 
thanks.
