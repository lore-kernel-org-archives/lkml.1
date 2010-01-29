Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894Ab0A2SzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab0A2SzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 13:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872Ab0A2SzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 13:55:17 -0500
Received: from web55007.mail.re4.yahoo.com ([206.190.58.141]:45377 "HELO
	web55007.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753864Ab0A2SzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 13:55:15 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=Fi3Ah6+sVyFLLGaExgvMyqn2RLvi9Nki9gBQ8tpLnghN6CQrP5csMic6dx29wXQnYpCt3FqE/7sLo5iv5TBs8R+z4n+7tkK0vGiS0tQ8oGMu95CkkZDwg1XyOBkePASqyhMdfg36sbiXuziJV552Vu7fvMeryBAjswX4B36akgQ=;
Message-ID: <229562.61603.qm@web55007.mail.re4.yahoo.com>
X-YMail-OSG: 8O9gqvUVM1lQEpUzlK5dmUYukrf.We4cKxyuIlb1OihDBt6IP6o0iY3SZsaMWGB.MAUJFFNl2.TBmvNoXNVNUadC3j07Is3b23noDjvzVcEMXWDKpqb61ett2a61Dif39oAquJoQ5iTdd_I0UlFJHbzQMC7QDZpdplG6vW9AordyHPATLh3FqF8RHKwl_ah3ptGCzFhTznqFqKSwUnR3SvhrnYEoFLZSgUYsz6wHezNItRBpuWCIq8bu_WF09fNe6._KiB7eofwYdPZ0kUBsmJcZIj.4U5SoR.inJ5g-
X-Mailer: YahooMailClassic/9.1.10 YahooMailWebService/0.8.100.260964
Date: Fri, 29 Jan 2010 10:55:13 -0800 (PST)
From: john smith <whalajam@yahoo.com>
Subject: Re: perf report for .ko files
To: Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100126210552.GA12567@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem1: 

> Well, you could reduce the number of samples collected by
> asking perf record to
> include only kernel samples by fiddling with these
> perf_event_attr fields:
> 
>  
>    exclude_user   :  1, /* don't count user      */
>    exclude_kernel :  1, /* ditto kernel          */
>    exclude_hv     :  1, /* ditto hypervisor      */
>    exclude_idle   :  1, /* don't count when idle */
> 
> I.e. setting exclude_user, exclude_hv and exclude_idle to
> 1, but this requires
> a patch for tools/perf/builtin-record.c as this is not
> exposed yet.

I did setup attr->exclude_hv, exclude_idle, exclude_user = 1 in create_counter() just before "try_again:" label, no difference in results,
on a 2.6.31 (too old? "perf buildid-list" is not available) kernel version:

# perf record -f -e cycles fio fio_script
(for more than a minute, I increased the sample frequency with different -c values, some locked the machine - expectedly)
and
# perf report --verbose --dso=/my_module_path/my_module.ko
(--verbose doesn't provide any more info)

return the same "# Samples: 0":

"
# dso: /my_module_path/my_module.ko
# Samples: 0
#...
"

> [root@doppio linux-2.6-tip]# perf report --dsos '[e1000e]'
> # dso: [e1000e]
> # Samples: 110518812

'e1000e' module may be be sampled more often than the scsi modules but ...

> > not sure why that is, /proc/kallsyms does seem to
> > include some iwlagn symbols.

/proc/kallsyms includes all syms I need, so is a problem not finding the symbols, does this (Samples: 0) make sens?

"perf report --sort comm,dso,symbol" report has my module symbols.

Problem2: 

If I try "perf annotate -l -k /my_module_path/my_module.ko my_symbol" has all the percentages "0.00" where I would expect a % breakdown (considering the total function counter 100%), even if the function represents a small overall counter % compared to the others, any ideas?

John



      
