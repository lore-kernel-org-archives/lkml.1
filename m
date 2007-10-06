Return-Path: <linux-kernel-owner+w=401wt.eu-S1765638AbXJFVL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765638AbXJFVL7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 17:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764691AbXJFVLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 17:11:48 -0400
Received: from smtp-out.google.com ([216.239.45.13]:6764 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764151AbXJFVLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 17:11:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=pn/AMuby437PBoMVxsiTTIOe1qJKUnGB0s4+VXVu5OczP1wtT7vx7QTR0FCVu10TN
	F01TNdD7lEAVO4tKuujWw==
Message-ID: <6599ad830710061411l3fb9368al319a80469d54946e@mail.gmail.com>
Date: Sat, 6 Oct 2007 14:11:43 -0700
From: "Paul Menage" <menage@google.com>
To: "David Rientjes" <rientjes@google.com>
Subject: Re: [PATCH] task containersv11 add tasks file interface fix for cpusets
Cc: "Paul Jackson" <pj@sgi.com>, "Andrew Morton" <akpm@linux-foundation.org>,
       nickpiggin@yahoo.com.au, a.p.zijlstra@chello.nl, serue@us.ibm.com,
       clg@fr.ibm.com, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       svaidy@linux.vnet.ibm.com, xemul@openvz.org, containers@lists.osdl.org,
       balbir@linux.vnet.ibm.com
In-Reply-To: <alpine.DEB.0.9999.0710061047400.24311@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071003084241.24279.62099.sendpatchset@jackhammer.engr.sgi.com>
	 <6599ad830710030851jb44f00ft9634f9381218b6e9@mail.gmail.com>
	 <20071003105817.7adf6516.pj@sgi.com>
	 <6599ad830710031110r1a74eafej56f20cc33e72ac81@mail.gmail.com>
	 <20071003131632.fed4b848.pj@sgi.com>
	 <6599ad830710031331h15d35e90lc63d845efd2de6f5@mail.gmail.com>
	 <20071006012437.c0fd3a8a.pj@sgi.com>
	 <alpine.DEB.0.9999.0710061047400.24311@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/6/07, David Rientjes <rientjes@google.com> wrote:
> The getting and putting of the tasks will prevent them from exiting or
> being deallocated prematurely.  But this is also a critical section that
> will need to be protected by some mutex so it doesn't race with other
> set_cpus_allowed().

Is that necessary? If some other process calls set_cpus_allowed()
concurrently with a cpuset cpus update, it's not clear that there's
any defined serialization semantics that have to be achieved, as long
as the end result is that the task's cpus_allowed are within the
cpuset's cpus_allowed.

Paul
