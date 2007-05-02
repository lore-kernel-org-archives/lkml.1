Return-Path: <linux-kernel-owner+w=401wt.eu-S2992654AbXEBDZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992654AbXEBDZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 23:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992659AbXEBDZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 23:25:56 -0400
Received: from smtp-out.google.com ([216.239.33.17]:17034 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992654AbXEBDZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 23:25:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=tZmrKjR7VOVF6n+BkPz0ktzr5EhNngLNliansYwFnx/UZnoGdqhQtI8x0oQEJO+fO
	HhEGWlbJRHGcQ2D6VnmMg==
Message-ID: <6599ad830705012025r64eed906sebe4b38d9977c036@mail.gmail.com>
Date: Tue, 1 May 2007 20:25:35 -0700
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [ckrm-tech] [PATCH 3/9] Containers (V9): Add tasks file interface
Cc: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com, haveblue@us.ibm.com,
       xemul@sw.ru, dev@sw.ru, rohitseth@google.com, pj@sgi.com,
       ebiederm@xmission.com, mbligh@google.com, containers@lists.osdl.org,
       serue@us.ibm.com, akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
       devel@openvz.org
In-Reply-To: <20070502032541.GA7311@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070427104607.252541000@menage.corp.google.com>
	 <20070427111300.406327000@menage.corp.google.com>
	 <46378311.6000703@linux.vnet.ibm.com>
	 <6599ad830705011337r6f200baen841919ac17c6f38b@mail.gmail.com>
	 <20070502032541.GA7311@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
>
> For the CPU controller I was working on, (a fast access to) such a list would
> have been valuable. Basically each task has a weight associated with it
> (p->load_weight) which is made to depend upon its class limit. Whenever
> the class limit changes, we need to go and change all its member task's
> ->load_weight value.
>
> If you don't maintain the per-container task list, I guess I could still
> work around it, by either:
>
>         - Walk the task table and find relevant members

That doesn't seem like a terrible solution to me, unless you expect
the class limit to be changing incredibly frequently.

If we had multiple subsystems that needed to walk the container member
list on a fast-path operation (e.g. to make a scheduling decision)
that would be a good reason to maintain such a list.

>           perhaps
>         - Move p->load_weight to a class structure

Sounds like a good idea if you can do it - but if it's per-process,
how would it fit in the class structure?

Paul
