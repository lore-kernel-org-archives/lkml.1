Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894Ab0A3GqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab0A3GqG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 01:46:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498Ab0A3GqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 01:46:05 -0500
Received: from mail.gmx.net ([213.165.64.20]:54858 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932065Ab0A3GqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 01:46:04 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18HIRVlXFQHGSQsypMcMDeqQs8d/Wl2KTAgvKwtHT
	1YHPnYi5KtSAQM
Subject: Re: perf report for .ko files
From: Mike Galbraith <efault@gmx.de>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: john smith <whalajam@yahoo.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100129191558.GA9990@ghostprotocols.net>
References: <20100126210552.GA12567@ghostprotocols.net>
	 <229562.61603.qm@web55007.mail.re4.yahoo.com>
	 <20100129191558.GA9990@ghostprotocols.net>
Content-Type: text/plain
Date: Sat, 30 Jan 2010 07:45:54 +0100
Message-Id: <1264833954.6097.13.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.56999999999999995
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 17:15 -0200, Arnaldo Carvalho de Melo wrote:

> I actually never tried doing annotation with a module, will try.

Seems it went south again in both .git and .tip.  32 works.

ed52ce2e3c33dc7626a40fa2da766d1a6460e543 is the first bad commit                             
commit ed52ce2e3c33dc7626a40fa2da766d1a6460e543                                              
Author: Arnaldo Carvalho de Melo <acme@redhat.com>                                           
Date:   Mon Oct 19 17:17:57 2009 -0200                                                       

    perf tools: Add ->unmap_ip operation to struct map
                                                      
    We need this because we get section relative addresses when
    reading the symtabs, but when a tool like 'perf annotate' needs
    to match these address to what 'objdump -dS' produces we need
    the address + section back again.

    So in annotate now we look at the 'struct hist_entry' instances
    (that weren't really being used) so that we iterate only over
    the symbols that had some hit and get the map where that
    particular hit happened so that we can get the right address to
    match with annotate.

    Verified that at least:

     perf annotate mmap_read_counter # Uses the ~/bin/perf binary
     perf annotate --vmlinux /home/acme/git/build/perf/vmlinux intel_pmu_enable_all

    on a 'perf record perf top' session seems to work.

    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Mike Galbraith <efault@gmx.de>
    LKML-Reference: <1255979877-12533-1-git-send-email-acme@redhat.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>


