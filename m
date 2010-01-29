Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171Ab0A2V7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab0A2V7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 16:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331Ab0A2V7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 16:59:36 -0500
Received: from web55003.mail.re4.yahoo.com ([206.190.58.137]:45258 "HELO
	web55003.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752709Ab0A2V7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 16:59:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=IKQq7PtkJPiow7RuvUf2uhZjrxYhgR1EQLDI0x4cfvWLcg+e8SYh8TYOGUx2NrnbdmlV+2W8YxEtIP88mshZiqIbLVwpuXjCATM6ErTloyY4Hq1XOwZVJrCUHbyM0heU5GERmC3ZVUfCklO3wiS3KnQZZzOGItiZudI54Ffot/s=;
Message-ID: <202042.73614.qm@web55003.mail.re4.yahoo.com>
X-YMail-OSG: tUsNdEIVM1nnOuaEzQXUKkpeRwDrzZ95Z.ljc5kJOPKHambYgSEL2Ecr41jk3uJS9T.fiRZQH1Ol75Yrb5dvAK6MLYzm._06pSadz_Qm9DdfMcf5OjMvc5V.6ovPhzA0Tw.HYZKXcPyr6jhtgb4.nNF3dIq.s7.BlGIvU2Tk3cXI7dgy_goW5Z3DskJYsD74gw6dQJVOuA_JfCAJXaoGhO_wh8HI07RA9cVrl_0-
X-Mailer: YahooMailClassic/9.1.10 YahooMailWebService/0.8.100.260964
Date: Fri, 29 Jan 2010 13:59:35 -0800 (PST)
From: john smith <whalajam@yahoo.com>
Subject: Re: perf report for .ko files
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20100129191558.GA9990@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I did setup attr->exclude_hv, exclude_idle,
> exclude_user = 1 in
> > create_counter() just before "try_again:" label, no
> difference in
> > results, on a 2.6.31 (too old? "perf buildid-list" is
> not available)
> > kernel version:
>  
> > # perf record -f -e cycles fio fio_script
> 
> > (for more than a minute, I increased the sample
> frequency with
> > different -c values, some locked the machine -
> expectedly)
> > and
> > # perf report --verbose
> --dso=/my_module_path/my_module.ko
> > (--verbose doesn't provide any more info)
> 
> This isn't going to work, you need to do:
> 
> perf report --verbose --dso='[my_module]'
> 
> I.e. as it appear on /proc/modules + brackets. Arguably we
> need to get
> it to work also with both 'my_module.ko' and the full
> path.

I've tried:
"perf report --verbose --dso='[my_module]'"
and also:
"perf report --verbose --dso='[sg]'"
same result as before.

New question:

Is this the minimal set of api that I can use from within the kernel (for specific module sections of interest) to read the counters? 

{
int perf_event_release_kernel(struct perf_event *event);
struct perf_event *perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu);
u64 perf_event_read_value(struct perf_event *event);
}

Any good example of useage of these api's (struct initialization)?

John
  



      
