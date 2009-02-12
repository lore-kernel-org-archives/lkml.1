Return-Path: <linux-kernel-owner+w=401wt.eu-S1760661AbZBLUjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760661AbZBLUjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 15:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758755AbZBLUiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 15:38:55 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:50072 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZBLUiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 15:38:54 -0500
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?utf-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
       mingo@elte.hu, linux-kernel@vger.kernel.org, oleg@redhat.com,
       travis@sgi.com, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: + work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch  added to -mm tree
References: <200902031058.n13AwOoK016719@imap1.linux-foundation.org>
	<20090203121147.GB19979@elte.hu>
	<c62985530902030858y28906b2dh511c5868afabfd17@mail.gmail.com>
	<20090203112529.26e6bf76.akpm@linux-foundation.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 12 Feb 2009 12:38:36 -0800
In-Reply-To: <20090203112529.26e6bf76.akpm@linux-foundation.org> (Andrew Morton's message of "Tue\, 3 Feb 2009 11\:25\:29 -0800")
Message-ID: <m18wobcrw3.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org, a.p.zijlstra@chello.nl, travis@sgi.com, oleg@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
>
> Series of four patches:
>
> - switch cstate.c frmo work_on_cpu to smp_call_function_single()
>
> - ditto acpi-cpufreq.c
>
> - ditto mce_amd_64.c
>
> The final work_on_cpu() caller is pci_call_probe().  I'd like to find a
> way of removing that callsite as well, so we can finally remove this
> turkey but for now, just fix the bugs in it:

As far as I can tell when we are doing the probes we are in a function
that can sleep, so we should be able to just call set_cpus_allowed to
remove the need for work_on_cpu in pci_call_probe.  Possibly with a
save/restore of the allowed cpus.

Am I missing something?

Eric


