Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633Ab0ARNA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab0ARNA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 08:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779Ab0ARNA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 08:00:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:5646 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab0ARNA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 08:00:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=D264wzD6kfCCV0PsKs62ewIQubCpcO9iyU2a0t/6J8m42bGISUzYgDJeRCBEn58zev
         mUndk2nNHUvLPTd8legdbnFkFfNOfP25znk7k1mPCObtc7kg7ziQRg8vGPuMP6byGuIA
         93MQ+XYDgoRXyEbFtfl+BJLRkZ5AafhDbLcfY=
Date: Mon, 18 Jan 2010 14:00:51 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 7/7] Ftrace plugin for Uprobes
Message-ID: <20100118130048.GA10364@nowhere>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com> <20100111122608.22050.94088.sendpatchset@srikar.in.ibm.com> <1263468191.4244.300.camel@laptop> <20100114113509.GB5033@nowhere> <1263469381.4244.308.camel@laptop> <20100114122329.GC5033@nowhere> <1263472149.4244.314.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263472149.4244.314.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 01:29:09PM +0100, Peter Zijlstra wrote:
> On Thu, 2010-01-14 at 13:23 +0100, Frederic Weisbecker wrote:
> > 
> > I see, so what you suggest is to have the probe set up
> > as generic first. Then the process that activates it
> > becomes a consumer, right?
> 
> Right, so either we have it always on, for things like ftrace, 
> 
>   in which case the creation traverses rmap and installs the probes
>   all existing mmap()s, and a mmap() hook will install it on all new
>   ones.
> 
> Or they're strictly consumer driver, like perf, in which case the act of
> enabling the event will install the probe (if its not there yet).
> 


Looks like a good plan.

