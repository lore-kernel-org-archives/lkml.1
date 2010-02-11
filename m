Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab0BKCRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 21:17:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40227 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab0BKCRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 21:17:40 -0500
Message-ID: <4B73689F.5090407@zytor.com>
Date: Wed, 10 Feb 2010 18:17:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com
Subject: Re: [patch v2 4/4] ptrace: Add support for generic	PTRACE_GETREGSET/PTRACE_SETREGSET
References: <20100209201309.902050211@sbs-t61.sc.intel.com>	<20100209202502.406177090@sbs-t61.sc.intel.com>	<20100210131826.GA21196@redhat.com> <20100210191240.DC9E4CC@magilla.sf.frob.com>
In-Reply-To: <20100210191240.DC9E4CC@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2010 11:12 AM, Roland McGrath wrote:
> 
> Since it's just two words, most places handling struct iovec seem to just
> use two get_user() calls, which is probably more efficient.
> 
> Also, here is where this function would need to be split in half for
> compat_ptrace_request() calls where it has to use struct compat_iovec.
> 
>> +	// I am not sure. Afaics it is OK to pass the
>> +	// size which is less than n * size. If iov_len
>> +	// is bigger, we can silently truncate it, or
>> +	// even write the correct value back.
> 
> Modifying iov_len to report how much we accessed seems good to me.  If we
> do that, we should certainly allow a larger size for get, so userland can
> just use a generic large buffer before even knowing the real size.  I'm not
> sure whether we should allow a smaller size, especially for set.  I could
> go either way.
> 

Allowing a larger size for get seems very sane.  Allowing a smaller size
would be ok iff we make sure we handle corner cases right (i.e. a
partially overwritten subregister.)

	-hpa
