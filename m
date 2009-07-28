Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbZG1ApK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbZG1ApK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 20:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbZG1ApJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 20:45:09 -0400
Received: from smtp-out.google.com ([216.239.33.17]:62944 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbZG1ApI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 20:45:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=O9q6/dRXqxrsfakSXVjetej2mD3DAhfbMiCkceks15JHHTX8uOZNPEIuRgYcN26Y1
	isjHLO0Gx1XiPw2HA01Lg==
Date: Mon, 27 Jul 2009 17:45:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Menage <menage@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mmotm] mm: introduce oom_adj_child
In-Reply-To: <6599ad830907271730y2f783042q87e1bed5d7130550@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0907271739230.29815@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0907261446050.12973@chino.kir.corp.google.com> <6599ad830907271648v41b006c0j727fc09665f4f47e@mail.gmail.com> <alpine.DEB.2.00.0907271658550.27881@chino.kir.corp.google.com>
 <6599ad830907271730y2f783042q87e1bed5d7130550@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009, Paul Menage wrote:

> > Ok, we can allow oom_adj_child to be less than oom_adj for
> > CAP_SYS_RESOURCE.
> 
> Sounds fine to me, since you already need CAP_SYS_RESOURCE to set
> oom_adj anyway. But actually, shouldn't you just be requiring
> CAP_SYS_RESOURCE to set oom_adj_child at all?
> 

Tasks can elevate their own oom_adj value without that capability.

> Otherwise an unprivileged process that starts with oom_adj=0 could set
> its oom_adj_child value to something slightly less immune than its
> oom_adj, say 1; then even if the sysadmin sets if oom_adj value to
> very non-immune, it would still be able to create children with
> oom_adj 1.
> 

Perhaps we should simply always change oom_adj_child to match oom_adj when 
oom_adj changes?  oom_adj_child could then change, but only more immune if 
CAP_SYS_RESOURCE.
