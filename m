Return-Path: <linux-kernel-owner+w=401wt.eu-S1752359AbZLBGGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbZLBGGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 01:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZLBGGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 01:06:51 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:14407 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbZLBGGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 01:06:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mApwy68Xq8uL0jEdR1HgwkYgt+wMraDPTXRhSAO+33Bhj4772cFNpfkOiFuRZjE9F4
         ZGhKykr9q0Ze75vdpuaV+vktQOM8giW68HEbst4ion9lwKryipBLOBgk32wwiQ5D0AX5
         NmNAWkV7np702t8umuTvbPZzsNTEgJn77XSqs=
Date: Wed, 2 Dec 2009 07:06:57 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Wang Liming <liming.wang@windriver.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, mingo@redhat.com,
       peterz@infradead.org, linux-kernel@vger.kernel.org, acme@redhat.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       fche@redhat.com, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com
Subject: Re: [tip:perf/core] perf probe: Add --list option for listing
	current probe events
Message-ID: <20091202060655.GB5719@nowhere>
References: <20091201002017.10235.76575.stgit@harusame> <tip-4de189fe6e5ad8241f6f8709d2e2ba4c3aeae33a@git.kernel.org> <4B15E913.1040105@windriver.com> <4B15F36F.5040304@redhat.com> <4B15FCAB.7000209@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B15FCAB.7000209@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 01:35:39PM +0800, Wang Liming wrote:
> Yes, my glibc is old so that "perf" can't be built. I'm using ubuntu 8.04.
>
> Thanks a lot.



What is your glibc version?
%m appears to be supported since 2.7

But if possible we would like perf to be buildable on most
boxes. May be should we use %a instead there.

odd gcc versions will whine because of the confusion with the %a for
floating point things but that can be worked around with (float *) casts (sigh).
Well, since we also have strict aliasing checks, we'll actually need:

scanf("%a", (float *)(void *)str);

We do that in util/trace-event-parse.c

