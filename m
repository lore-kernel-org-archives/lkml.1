Return-Path: <linux-kernel-owner+w=401wt.eu-S1762422AbYFDTfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762422AbYFDTfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760370AbYFDTee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:34:34 -0400
Received: from smtp-out.google.com ([216.239.33.17]:59021 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762112AbYFDTed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:34:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=TJQafxt4j9EW1kR02XMNTlzfv5Af5kROY2021KxF3gHsHVW75XCRni+BUDYBnKGOz
	r2D2pK4MAp9EAsI4Ck5GA==
Date: Wed, 4 Jun 2008 12:33:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: menage@google.com, miaox@cn.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpusets: update tasks' cpus_allowed and mems_allowed
 after CPU/NODE offline/online
In-Reply-To: <20080604142540.6fa2bcc3.pj@sgi.com>
Message-ID: <alpine.DEB.1.10.0806041232190.22192@chino.kir.corp.google.com>
References: <4845F864.8060102@cn.fujitsu.com> <6599ad830806040230l24bd1201y3cc0ea0273d835ad@mail.gmail.com> <6599ad830806040258h552e4623m5efae8202c5d026d@mail.gmail.com> <20080604122227.a092e70e.pj@sgi.com> <alpine.DEB.1.10.0806041149560.21323@chino.kir.corp.google.com>
 <20080604142540.6fa2bcc3.pj@sgi.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008, Paul Jackson wrote:

> > That would identify both kthreads that have been created with a subsequent 
> > call to set_cpus_allowed() or kthread_bind().
> 
> Or do I misunderstand?
> 
> If I am reading you correctly, then would it work to have a check in the
> cpuset code (rather than in the lower set_cpus_allowed() routine),
> where that check refused to move tasks out of the root cpuset if they
> were (1) kernel threads (mm NULL) and (2) had cpus_allowed that were a
> strict subset of the root cpusets 'cpus' (the online cpus).
> 

No, because sched_setaffinity() can still move the threads.
