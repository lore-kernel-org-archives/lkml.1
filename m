Return-Path: <linux-kernel-owner+w=401wt.eu-S1751395AbZJWHVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbZJWHVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 03:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbZJWHVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 03:21:36 -0400
Received: from mail-px0-f171.google.com ([209.85.216.171]:56139 "EHLO
	mail-px0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbZJWHVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 03:21:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=T6ZpwPv1jjFip87JSP3vFNZnspdFVpGjEFY9809mAiopbkWz7iJKRWQlQW+ldS9Fni
         eKgY31X9Vr+PHSgXu83rDhu3RTAl+DgNX13f15WxafSCmDQGdabLROUIH5TxoGw8YJ8/
         UnVsyIqPI5YhYxqwHznFULjDahbkri11mKIMk=
Subject: Re: [PATCH -v4 4/9] tracing: add static function tracer support
 for MIPS
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: David Daney <ddaney@caviumnetworks.com>
Cc: Richard Sandiford <rdsandiford@googlemail.com>,
       Adam Nemet <anemet@caviumnetworks.com>, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>
In-Reply-To: <4AE0A5BE.8000601@caviumnetworks.com>
References: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com>
	 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256135456.git.wuzhangjin@gmail.com>
	 <3f0d3515f74a58f4cfd11e61b62a129fdc21e3a7.1256135456.git.wuzhangjin@gmail.com>
	 <ea8aa927fbd184b54941e4c2ae0be8ea0b4f6b8a.1256135456.git.wuzhangjin@gmail.com>
	 <1256138686.18347.3039.camel@gandalf.stny.rr.com>
	 <1256233679.23653.7.camel@falcon>  <4AE0A5BE.8000601@caviumnetworks.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Fri, 23 Oct 2009 15:21:27 +0800
Message-Id: <1256282487.6381.20.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-22 at 11:34 -0700, David Daney wrote:
> Wu Zhangjin wrote:
> > On Wed, 2009-10-21 at 11:24 -0400, Steven Rostedt wrote:
> [...]
> >>> +
> >>> +NESTED(_mcount, PT_SIZE, ra)
> >>> +	RESTORE_SP_FOR_32BIT
> >>> +	PTR_LA	t0, ftrace_stub
> >>> +	PTR_L	t1, ftrace_trace_function /* please don't use t1 later, safe? */
> >> Is t0 and t1 safe for mcount to use? Remember, mcount does not follow
> >> the dynamics of C function ABI.
> > 
> > So, perhaps we can use the saved registers(a0,a1...) instead.
> > 
> 
> a0..a7 may not always be saved.
> 
> You can use at, v0, v1 and all the temporary registers.  Note that for 
> the 64-bit ABIs sometimes the names t0-t4 shadow a4-a7.  So for a 64-bit 
> kernel, you can use: $1, $2, $3, $12, $13, $14, $15, $24, $25, noting 
> that at == $1 and contains the callers ra.  For a 32-bit kernel you can 
> add $8, $9, $10, and $11

before the profiling source code(jal _mcount), there are only necessary
stack operations, nobody have touched the GPRs, so, I think we are safe
to use any of them, that's why the t0,t1 I have used not fail. and
'Cause the a0,a1 is used as the arguments to the real profiling
function, so, I will keep back to use t0, t1, as David Daney said $12,
$13 in 64bit and $8, $9 in 32bit.

Thanks!

Regards,
	Wu Zhangjin

