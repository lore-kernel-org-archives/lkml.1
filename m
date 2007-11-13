Return-Path: <linux-kernel-owner+w=401wt.eu-S1762938AbXKMWXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762938AbXKMWXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 17:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760075AbXKMWXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 17:23:12 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:54810 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760720AbXKMWXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 17:23:10 -0500
Date: Tue, 13 Nov 2007 14:22:34 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@osdl.org, Robert Richter <robert.richter@amd.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, perfmon@napali.hpl.hp.com,
       William Cohen <wcohen@redhat.com>, perfmon2-devel@lists.sourceforge.net
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071113222234.GH5747@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20071109213829.GC28276@kroah.com> <p73abpl2654.fsf@bingen.suse.de> <20071113151718.GA3804@erda.amd.com> <4739C42F.8030208@redhat.com> <20071113175545.GD4319@frankl.hpl.hp.com> <4739EE13.2090006@redhat.com> <20071113211345.GB5747@frankl.hpl.hp.com> <20071113212902.GA17593@one.firstfloor.org> <20071113214628.GE5747@frankl.hpl.hp.com> <20071113215056.GB17593@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113215056.GB17593@one.firstfloor.org>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,
On Tue, Nov 13, 2007 at 10:50:56PM +0100, Andi Kleen wrote:
> > Yes, horribly more complicated because of locking issues within perfmon.
> > As soon as you expose a file descriptor, you need some locking to prevent
> > multiple user threads (malicious or not) to compete to access the PMU state.
> 
> Why do you need the file descriptor? 
> 

To identify your monitoring session be it system-wide (i.e., per-cpu) or per-thread.
file descriptor allows you to use close, read, select, poll and you leverage the
existing file descriptor sharing/inheritance sematics. At the kernel level, a 
descriptor provides all the callback necessary to make sure you clean up the perfmon
session state on exit.


> One of the main problems with perfmon is the complicated user interface.
> 
> Naively I would assume just some thread global state should be sufficient. 
> 
> > I think the value add of NMI can be as well achieved with advanced PMU features
> > such as Intel Core 2 PEBS.
> 
> True probably, although only on CPUs that support PEBS. Dropping features
> for old CPUs is unfortunately quite difficult in Linux, and in this case
> probably not an option because there are so many of them (e.g. all of AMD
> not Fam10h) 
> 

Yes, I know that. Also note that unfortunately, AMD Fam10h IBS feature does not
allow you to capture more than one sample in critical sections. It is still
interrupt based sampling with one entry-deep buffer: one interrupt = one sample.
Perfmon does support NMI though it is much more expensive to use.

-- 
-Stephane
