Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbXKMIAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbXKMIAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 03:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbXKMH77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 02:59:59 -0500
Received: from smtp-out.google.com ([216.239.33.17]:14304 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbXKMH76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 02:59:58 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=ycAno50IPWJZtUqNwaS93FfT7jhQWX0f9XsjvpoHODUFXAAseElbQvYL7CmILUb3t
	w50wKVzDRmn1yDC1CuaTg==
Message-ID: <6599ad830711122359s5a4397f1ye6df324f57449721@mail.gmail.com>
Date: Mon, 12 Nov 2007 23:59:50 -0800
From: "Paul Menage" <menage@google.com>
To: vatsa@linux.vnet.ibm.com
Subject: Re: Revert for cgroups CPU accounting subsystem patch
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20071113075946.GA14731@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6599ad830711122125u576e85a6w428466a0ab46dbc6@mail.gmail.com>
	 <20071113060038.GC3359@linux.vnet.ibm.com>
	 <6599ad830711122205g88aae4fua8dd76cf6e8ab84d@mail.gmail.com>
	 <47394B84.8030008@linux.vnet.ibm.com>
	 <6599ad830711122310nf7530cfs5ef1fea061b1252c@mail.gmail.com>
	 <47395277.1060006@linux.vnet.ibm.com>
	 <20071113075946.GA14731@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 12, 2007 11:59 PM, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
>
> Thinking of it more, this requirement to "group tasks for only accounting
> purpose" may be required for other resources (mem, io, network etc) as well?
> Should we have a generic accounting controller which can provide these
> various resource usgae stats for a group (cpu, mem etc) by iterating thr' the
> task list for the group and summing up the corresponding stats already present
> in task structure?

In theory it could certainly be useful - but it can only be done if
something in the kernel is already keeping track of resources on a
per-task basis. This works for CPU, but isn't really possible for
memory without doing something lame like just adding up the tasks' RSS
values (since the page accounting is the hard part - limiting is easy
once you have accounting).

Paul
