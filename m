Return-Path: <linux-kernel-owner+w=401wt.eu-S1751806AbXKMH5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbXKMH5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 02:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbXKMH5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 02:57:13 -0500
Received: from smtp-out.google.com ([216.239.33.17]:14180 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbXKMH5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 02:57:12 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=ZtnTRohUpED9vtd9qKZDm+RkFdDgW8yDA1pyYF+U3jWozB+DNQhxNhcOJ1ClV+HXv
	n55i64KpzzIHtw7cuatCQ==
Message-ID: <6599ad830711122357i60482475o10c0e0935a9e00c0@mail.gmail.com>
Date: Mon, 12 Nov 2007 23:57:03 -0800
From: "Paul Menage" <menage@google.com>
To: vatsa@linux.vnet.ibm.com
Subject: Re: Revert for cgroups CPU accounting subsystem patch
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>
In-Reply-To: <20071113074805.GA13499@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6599ad830711122125u576e85a6w428466a0ab46dbc6@mail.gmail.com>
	 <20071113060038.GC3359@linux.vnet.ibm.com>
	 <6599ad830711122205g88aae4fua8dd76cf6e8ab84d@mail.gmail.com>
	 <20071113074805.GA13499@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 12, 2007 11:48 PM, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
>
> Regarding your concern about tracking cpu usage in different ways, it
> could be mitigated if we have cpuacct controller track usage as per
> information present in a task's sched entity structure
> (tsk->se.sum_exec_runtime) i.e call cpuacct_charge() from
> __update_curr() which would accumulate the execution time of the
> group in a SMP friendly manner (i.e dump it in a per-cpu per-group counter
> first and then aggregate to a global per-group counter).

That seems more reasonable than the current approach in cpu_acct.c

Paul
