Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbXJWQmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbXJWQmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 12:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbXJWQmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 12:42:03 -0400
Received: from smtp-out.google.com ([216.239.33.17]:52608 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbXJWQmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 12:42:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=KUKohehvevF8qYizQeqzAzS753eoVN5J9j+IlNcYMbx6jApGL2xz5FevEm71/86ED
	EylU11/e2uHQnBEoyZ59A==
Message-ID: <6599ad830710230941y5d175688ob3a4d9ac42ba8c8f@mail.gmail.com>
Date: Tue, 23 Oct 2007 09:41:49 -0700
From: "Paul Menage" <menage@google.com>
To: vatsa@linux.vnet.ibm.com
Subject: Re: [PATCH 2/2] CFS CGroup: Report usage
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Srivatsa Vaddagiri" <vatsa@in.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071023164704.GE4667@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <471D4523.4040509@google.com>
	 <20071023164704.GE4667@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/07, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
> > Adds a cpu.usage file to the CFS cgroup that reports CPU usage in
> > milliseconds for that cgroup's tasks
>
> It would be nice to split this into user and sys time at some point.

Sounds reasonable - but does CFS track this?

> We have also received request to provide idle time for a
> container/cgroup.

The semantics of "idle time" for a cgroup on a shared system seem a
bit fuzzy. How would you define it?

Suppose you have two cgroups that would each want to use, say, 55% of
a CPU - technically they should each be regarded as having 45% idle
time, but if they run on a the same CPU the chances are that they will
both always have some processes on their runqueue due to contention
with the other group. So how would you measure the difference between
this and a cgroup that really is trying to use 100%?

Paul
