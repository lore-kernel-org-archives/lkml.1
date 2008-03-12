Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbYCLDJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbYCLDJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 23:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYCLDJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 23:09:42 -0400
Received: from smtp-out.google.com ([216.239.33.17]:4043 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbYCLDJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 23:09:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=R3LqI2ETikUU/2c5Di2K3FVWih2CPMiuHKZYpS9DfAp2EGBgbt45VyP2nVAMXtQRi
	ngtEmbK+eAzs9bDNKmsUw==
Message-ID: <6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com>
Date: Tue, 11 Mar 2008 20:09:35 -0700
From: "Paul Menage" <menage@google.com>
To: "Max Krasnyansky" <maxk@qualcomm.com>
Subject: Re: boot cgroup questions
Cc: "Paul Jackson" <pj@sgi.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47D74595.4080100@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47D73086.2030008@qualcomm.com>
	 <6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>
	 <47D7411E.1000009@qualcomm.com>
	 <6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>
	 <47D74595.4080100@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 7:53 PM, Max Krasnyansky <maxk@qualcomm.com> wrote:
> It probably won't even affect your existing scripts since
> they will be able to move tasks into another set just like they do now.

My boot scripts look in /dev/cpuset/tasks to find processes to move
into the system cpuset. So that would break them.

>  they will now have to unset it in the 'boot' set as well.

That can break existing userspace, so I presume PaulJ isn't in favour
of this change.

> Otherwise since the
>  'boot' set will be non-exclusive (cpus and mems) it should not really affect
>  anything.

Apart from other cpusets that *are* mem_exclusive or cpu_exclusive.

>  So what's your concern with unconditional 'boot' cgroup/cpuset ?

The exclusivity problem, as above.

Which subsystems are you going to include in this boot hierarchy?
Userspace is going to have to be aware of the fact that there's a
cpusets hierarchy which might have to be dismantled if it wants to set
up something different.

Paul
