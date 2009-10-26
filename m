Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbZJZQQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbZJZQQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 12:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbZJZQQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 12:16:32 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:19578 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbZJZQQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 12:16:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=cFeY5DlNYKpF/LF1IhXMthBEDZ90zS7FJhc9JGsc14wcLCmbkSLqK1jEqadhgXMrip
         qalFSaBhsqTMonSxLHUlkoLVXluLy/l6AUiSAYw0Afoz+U3uFjuEleAWTcmEEQa28aoj
         2xXy1/NDyCDG+4WwBF98YPw5InoEzMLeFRhz4=
Subject: Re: [PATCH -v6 05/13] tracing: enable
 HAVE_FUNCTION_TRACE_MCOUNT_TEST for MIPS
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>, rostedt@goodmis.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>
In-Reply-To: <4AE5C344.4020104@ru.mvista.com>
References: <cover.1256569489.git.wuzhangjin@gmail.com>
	 <747deea2f18d5ccffe842df95a9dd1c86251a958.1256569489.git.wuzhangjin@gmail.com>
	 <3f47087b70a965fd679b17a59521671296457df1.1256569489.git.wuzhangjin@gmail.com>
	 <f290e125634d164ec65b09b24b269815f78455ab.1256569489.git.wuzhangjin@gmail.com>
	 <07dc907ec62353b1aca99b2850d3b2e4b734189a.1256569489.git.wuzhangjin@gmail.com>
	 <374da7039d2e1b97083edd8bcd7811356884d427.1256569489.git.wuzhangjin@gmail.com>
	 <4AE5C344.4020104@ru.mvista.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Tue, 27 Oct 2009 00:16:20 +0800
Message-Id: <1256573780.5642.216.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 18:41 +0300, Sergei Shtylyov wrote:
> Hello.
> 
> Wu Zhangjin wrote:
> 
> > There is an exisiting common ftrace_test_stop_func() in
> > kernel/trace/ftrace.c, which is used to check the global variable
> > ftrace_trace_stop to determine whether stop the function tracing.
> 
> > This patch implepment the MIPS specific one to speedup the procedure.
> 
> > Thanks goes to Zhang Le for Cleaning it up.
> 
> > Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
> 
> [...]
> 
> > diff --git a/arch/mips/kernel/mcount.S b/arch/mips/kernel/mcount.S
> > index 0c39bc8..5dfaca8 100644
> > --- a/arch/mips/kernel/mcount.S
> > +++ b/arch/mips/kernel/mcount.S
> > @@ -64,6 +64,10 @@
> >  	.endm
> >  
> >  NESTED(_mcount, PT_SIZE, ra)
> > +	lw	t0, function_trace_stop
> > +	bnez	t0, ftrace_stub
> > +	nop
> 
> 1) unless .set noreorder is specified in this file, explicit nop is not needed;
> 
> 2) delay slot instruction is usually denoted by adding extra space on its 
> left, like this:
> 
> 	bnez	t0, ftrace_stub
> 	 nop
> 

Okay, Will add an extra space for them later, thanks!

Regards,
	Wu Zhangjin

