Return-Path: <linux-kernel-owner+w=401wt.eu-S1760589AbZF3AG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760589AbZF3AG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 20:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbZF3AGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 20:06:49 -0400
Received: from smtp-out.google.com ([216.239.45.13]:14909 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbZF3AGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 20:06:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=vsv+6Y1sVhi26UHzQMl7QD/fpL4l9sVkcmAiOUSm/IUtIhk4KYs6JI+pgVF6w7vn6
	2MqL6Fu0yR5cAoAmq4mug==
Date: Mon, 29 Jun 2009 17:06:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Thomas Meyer <thomas@m3y3r.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       dccp@vger.kernel.org
Subject: Re: [Bug #13666] WARNING: at mm/page_alloc.c:1743
 __alloc_pages_nodemask
In-Reply-To: <6JJ2m5kyucK.A.cBC.0IASKB@chimera>
Message-ID: <alpine.DEB.2.00.0906291703430.17663@chino.kir.corp.google.com>
References: <ij4ZQY4URcP.A.F3B.vIASKB@chimera> <6JJ2m5kyucK.A.cBC.0IASKB@chimera>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13666
> Subject		: WARNING: at mm/page_alloc.c:1743 __alloc_pages_nodemask
> Submitter	: Thomas Meyer <thomas@m3y3r.de>
> Date		: 2009-06-27 16:15 (2 days old)
> References	: http://lkml.org/lkml/2009/6/27/75
> 

dccp_init() is trying to allocate a goal that causes the order in 
__get_free_pages() to be >= MAX_ORDER.  

Arnaldo, can we cap ehash_order and bhash_order at MAX_ORDER - 1?
