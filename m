Return-Path: <linux-kernel-owner+w=401wt.eu-S1759803AbZC0Rhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759803AbZC0Rhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 13:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbZC0Rhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 13:37:42 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:57940 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbZC0Rhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 13:37:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Nw9II9nhgzNgi4oJUTaBb+hjhTh1d0A4LCTU+90DR/Q+60m6YtGXgoHUaVg3s0Xb27
         /fV4QyXLNy6nEMDMinWwWQLoXA4sltdkF2sQ13hf05htTFcIo/dD9/cua1IpKHUb8nVg
         NpVMGYQ9llgSA5kER9rqKtFJVSS717lSIqATU=
Subject: Re: [patch 1/14] x86, ptrace: add arch_ptrace_report_exit
From: Markus Metzger <markus.t.metzger@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
In-Reply-To: <20090327170709.GB25762@redhat.com>
References: <20090327094626.A11002@sedona.ch.intel.com>
	 <20090327141937.GB14504@redhat.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E9266B6B4@irsmsx504.ger.corp.intel.com>
	 <20090327170709.GB25762@redhat.com>
Content-Type: text/plain
Date: Fri, 27 Mar 2009 18:37:28 +0100
Message-Id: <1238175448.6077.22.camel@raistlin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-27 at 18:07 +0100, Oleg Nesterov wrote:
> On 03/27, Metzger, Markus T wrote:
> >
> > >-----Original Message-----
> > >From: Oleg Nesterov [mailto:oleg@redhat.com]
> > >
> > >This needs Rolan'd review.
> > >
> > >But I'd say this has nothing to do with tracehooks. And why do
> > >you pass *exit_code to arch_ptrace_report_exit() ?
> > >
> > >Just add arch_ptrace_report_exit(void) into do_exit() ?
> > >
> > >From the 3/14 patch:
> > >
> > >	#define arch_ptrace_report_exit(code) x86_ptrace_report_exit(code)
> > >
> > >	void x86_ptrace_report_exit(long exit_code)
> > >	{
> > >	       ptrace_bts_exit();
> > >	}
> > >
> > >This is a bit strange. Why do we need 2 functions, ptrace_bts_exit() and
> > >x86_ptrace_report_exit() which just calls the first one?
> >
> > I did not want to take any shortcuts. I try to maintain the structure
> > general_function()->ptrace_report()->arch_ptrace_report().
> 
> I see. And honestly, this doesn't look good to me. Yes, this is subjective.
> 
> Say, Regardless of CONFIG_X86_PTRACE_BTS we have the non-empty and non-inline
> x86_ptrace_untrace() which just calls ptrace_bts_untrace(). And ptrace_bts_untrace()
> depends on CONFIG_X86_PTRACE_BTS.
> 
> But this is minor.
> 
> > Recently, tracehook_report_whatever() calls were added which either do the
> > ptrace work directly or call a ptrace function. I try to use those calls, where possible.
> 
> Up to Roland, but I still think tracehook_report_whatever() is not the
> good place for this stuff. And tracehooks will be changed soon by utrace.
> 
> In any case I don't understand why you added yet another helper, you could
> just add arch_ptrace_report_exit() into tracehook_report_exit().

Fine with me.
I did not want to add some arch_ptrace stuff in tracehook, but I can
change that.

regards,
markus.


