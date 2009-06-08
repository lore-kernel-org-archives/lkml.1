Return-Path: <linux-kernel-owner+w=401wt.eu-S1752976AbZFHTCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbZFHTCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbZFHTCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:02:41 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:33254 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbZFHTCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:02:41 -0400
Message-ID: <4A2D6041.4050309@linux.vnet.ibm.com>
Date: Mon, 08 Jun 2009 12:02:25 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_counter: extensible perf_counter_attr
References: <1244481941.13761.9119.camel@twins>
In-Reply-To: <1244481941.13761.9119.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Peter Zijlstra wrote:
> Allow extending the perf_counter_attr structure by linking extended
> structures to it.
> 
> Also, should we grow the directly reserved space in the structure a
> little more?
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/perf_counter.h |    7 +++++++
>  kernel/perf_counter.c        |    1 +
>  2 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
> index 3586df8..781d8ce 100644
> --- a/include/linux/perf_counter.h
> +++ b/include/linux/perf_counter.h
> @@ -175,6 +175,13 @@ struct perf_counter_attr {
>  	__u32			__reserved_3;
> 
>  	__u64			__reserved_4;
> +
> +	struct perf_counter_attr_ext *ext_attrs;
> +};
> +
> +struct perf_counter_attr_ext {
> +	struct perf_counter_attr_ext 	*next;
> +	__u64				perf_attr_ext_type;
>  };

Let's say I want to extend the attributes by four 64-bit quantities... from the 
above definition, I'd need four additional records chained together, right?  How 
about something like this instead:

struct perf_counter_attr_ext {
     __u32	num_perf_attrs;
     __u64 	*perf_attr_ext;
};

Another alternative would be to place these two fields into perf_counter_attr 
and so eliminate the extra level of indirection.


Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
cjashfor@us.ibm.com

