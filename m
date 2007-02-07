Return-Path: <linux-kernel-owner+w=401wt.eu-S1422779AbXBGVTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422779AbXBGVTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 16:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422786AbXBGVTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 16:19:53 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54440 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422779AbXBGVTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 16:19:52 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 6/6] automatic tuning applied to some kernel components
References: <20070116061516.899460000@bull.net>
	<20070116063030.761795000@bull.net>
	<20070122115638.835b26a1.akpm@osdl.org> <45B61E50.6020607@bull.net>
Date: Wed, 07 Feb 2007 14:18:57 -0700
In-Reply-To: <45B61E50.6020607@bull.net> (Nadia Derbey's message of "Tue, 23
	Jan 2007 15:40:16 +0100")
Message-ID: <m1mz3poeda.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nadia Derbey <Nadia.Derbey@bull.net> writes:

>
> 2) why autotuning:
> There are at least 3 cases where it can be useful
> . for workloads that are known to need a big amount of a given resource type
> (say shared memories), but we don't know what the maximum amount needed will be
> . to solve the case of multiple applications running on a single system, and
> that need the same tunable to be adjusted to feet their needs
> . to make a system correctly react to eventual peak loads for a given resource
> usage, i.e. make it tune up *and down* as needed.

>
> In all these cases, the akt framework will enable the kernel to adapt to
> increasing / decreasing resource consumption:
> 1) avoid allocating "a priori" a big amount of memory that will be used only in
> extreme cases. This is the effect of doing an "echo <huge_value>
>> /proc/sys/kernel/shmmni"
>
> 2) the system will come back to the default values as soon as the peak load is
> over.

At least the ipc ones are supposed to be DOS limits not behavior
modifiers.  I do admit from looking at the code that there are some
consequences of increasing things like shmmni.  However I think we
would be better off with  better data structures and implementations
that remove these consequences than this autotuning of
denial-of-service limits.

i.e. I think you are treating the symptom not the problem.

Does this make sense?

Eric

