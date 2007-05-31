Return-Path: <linux-kernel-owner+w=401wt.eu-S1758257AbXEaPVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbXEaPVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 11:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755417AbXEaPVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 11:21:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46306 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbXEaPVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 11:21:36 -0400
Date: Thu, 31 May 2007 16:21:34 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Stephane Eranian <eranian@frankl.hpl.hp.com>
Cc: linux-kernel@vger.kernel.org, eranian@hpl.hp.com
Subject: Re: [PATCH 03/22] 2.6.22-rc3 perfmon2 : new system calls support
Message-ID: <20070531152134.GA974@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Stephane Eranian <eranian@frankl.hpl.hp.com>,
	linux-kernel@vger.kernel.org, eranian@hpl.hp.com
References: <200705291348.l4TDmHQd019645@frankl.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705291348.l4TDmHQd019645@frankl.hpl.hp.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 06:48:17AM -0700, Stephane Eranian wrote:
> sys_pfm_create_context():
> 	- create a new perfmon2 context and returns a file descriptor in
> 	  the pfarg_ctx_t parameters. This is the first call an application
> 	  must make to do monitoring 
> 	- rewritten to pass sampling format identification as a string
> 	- file descriptor is now returned by call
> 
> sys_pfm_write_pmcs():
> 	- program the PMU configuration registers. Accepts vector of arguments
> 	  of type pfarg_pmc_t
> 	
> sys_pfm_write_pmds():
> 	- program the PMU data registers. Accepts a vector of arguments of type
> 	  pfarg_pmd_t
> 
> sys_pfm_read_pmds():
> 	- read the PMU data registers.  Accepts a vector of arguments of type
> 	  pfarg_pmd_t

This kind of interface doesn't make any sense at all.  Information should
be read and written from filedescriptors using the read and write family
syscalls and through the VFS instead of adding tons of system calls.

I fear we need to write down the requirements first and then come up
with something better.  E.g. for per-task sampling an interface centered
around a few files in /proc/<pid>/ would fit very nicely:

  /proc/<pid>/perfmon_pmcs
  /proc/<pid>/perfmon_pmds
  	Obvious
  /proc/<pid>/perfmon_ctl
  	Can get control commands as ascii sets written to


