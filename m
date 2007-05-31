Return-Path: <linux-kernel-owner+w=401wt.eu-S1759273AbXEaP6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273AbXEaP6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 11:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbXEaP6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 11:58:46 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:62720 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312AbXEaP6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 11:58:45 -0400
Date: Thu, 31 May 2007 08:46:15 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/22] 2.6.22-rc3 perfmon2 : new system calls support
Message-ID: <20070531154615.GA23939@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <200705291348.l4TDmHQd019645@frankl.hpl.hp.com> <20070531152134.GA974@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531152134.GA974@infradead.org>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph,

On Thu, May 31, 2007 at 04:21:34PM +0100, Christoph Hellwig wrote:
> On Tue, May 29, 2007 at 06:48:17AM -0700, Stephane Eranian wrote:
> > sys_pfm_create_context():
> > 	- create a new perfmon2 context and returns a file descriptor in
> > 	  the pfarg_ctx_t parameters. This is the first call an application
> > 	  must make to do monitoring 
> > 	- rewritten to pass sampling format identification as a string
> > 	- file descriptor is now returned by call
> > 
> > sys_pfm_write_pmcs():
> > 	- program the PMU configuration registers. Accepts vector of arguments
> > 	  of type pfarg_pmc_t
> > 	
> > sys_pfm_write_pmds():
> > 	- program the PMU data registers. Accepts a vector of arguments of type
> > 	  pfarg_pmd_t
> > 
> > sys_pfm_read_pmds():
> > 	- read the PMU data registers.  Accepts a vector of arguments of type
> > 	  pfarg_pmd_t
> 
> This kind of interface doesn't make any sense at all.  Information should
> be read and written from filedescriptors using the read and write family
> syscalls and through the VFS instead of adding tons of system calls.
> 

They are all using file descriptors already.
We use read() for receiving overflow notifications. Write is not used.

> I fear we need to write down the requirements first and then come up
> with something better.  E.g. for per-task sampling an interface centered
> around a few files in /proc/<pid>/ would fit very nicely:
> 
>   /proc/<pid>/perfmon_pmcs
>   /proc/<pid>/perfmon_pmds
>   	Obvious
>   /proc/<pid>/perfmon_ctl
>   	Can get control commands as ascii sets written to
> 
You don't want to do parsing because usually, when sampling, you have
to reprogram the registers on the fly and this is on the critical path.
Information has to be exchanged in binary format.

-- 

-Stephane
