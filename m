Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbZEKToc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbZEKToc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbZEKToU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:44:20 -0400
Received: from smtp-out.google.com ([216.239.45.13]:32724 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbZEKToT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:44:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Cm3deO46i0qPGoy/4RFtWI9YoQR6MQ+f265nb46fRqcpvBLJGLhhIExyt6/HhsMA0
	ENGclN57HVnYu8LwidlOg==
Date: Mon, 11 May 2009 12:44:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rik van Riel <riel@redhat.com>
cc: Greg KH <greg@kroah.com>,
       =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, San Mehat <san@android.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: [patch 1/5] oom: cleanup android low memory killer
In-Reply-To: <49FF7B02.9050608@redhat.com>
Message-ID: <alpine.DEB.2.00.0905111241120.23739@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905031305130.18426@chino.kir.corp.google.com> <d6200be20905041448p1ca2d068r5ba8348488842b5c@mail.gmail.com> <20090504220905.GA29402@kroah.com> <alpine.DEB.2.00.0905041529570.2310@chino.kir.corp.google.com> <20090504225936.GA9876@kroah.com>
 <alpine.DEB.2.00.0905041607170.6073@chino.kir.corp.google.com> <49FF7B02.9050608@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 May 2009, Rik van Riel wrote:

> > There was an interest in a low mem userspace notifier that applications can
> > poll() on at configurable low mem levels to react accordingly.  This would
> > probably address the problem that the Android team is trying to fix.
> 
> This would also make it easier for virtual machines to be
> ballooned down to size when the host experiences memory
> pressure.
> 
> The low memory notification could also be useful for JVMs,
> databases that do (some of) their own caching and any garbage
> collected program in general.
> 

I agree, and I'd suggest that it be implemented as a cgroup so that 
individual sets of tasks can be responsible for their own lowmem 
notifiers.

KOSAKI, you were pushing the /dev/mem_notify patchset last year from 
Marcelo.  Do you have any plans of recreating that in a cgroup or have you 
dropped it?
