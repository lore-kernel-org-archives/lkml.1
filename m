Return-Path: <linux-kernel-owner+w=401wt.eu-S933075AbXJOUpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075AbXJOUpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755656AbXJOUpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:45:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46353 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbXJOUpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:45:09 -0400
Date: Mon, 15 Oct 2007 16:32:47 -0400
From: Dave Jones <davej@redhat.com>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Andy Whitcroft <apw@shadowen.org>, Andi Kleen <andi@firstfloor.org>,
       cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][try 3] architectural pstate driver for powernow-k8
Message-ID: <20071015203247.GA14279@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Mark Langsdorf <mark.langsdorf@amd.com>,
	Andy Whitcroft <apw@shadowen.org>, Andi Kleen <andi@firstfloor.org>,
	cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org
References: <200710091446.38432.mark.langsdorf@amd.com> <20071011075958.GK1130@shadowen.org> <20071015154031.GA30754@redhat.com> <200710151123.45582.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200710151123.45582.mark.langsdorf@amd.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 11:23:45AM -0500, Mark Langsdorf wrote:
 > On Monday 15 October 2007 10:40, Dave Jones wrote:
 > > On Thu, Oct 11, 2007 at 08:59:58AM +0100, Andy Whitcroft wrote:
 > >  
 > >  > >  	/* get fid did for hardware pstate transition */
 > >  > >  	pstate = index & HW_PSTATE_MASK;
 > >  > > -	if (pstate > MAX_HW_PSTATE)
 > >  > > +	if (pstate > data->max_hw_pstate);
 > >  > >  		return 0;
 > >  > 
 > >  > checkpatch picked up this dodgy if.  I suspect that the ';' is wrong
 > >  > from the context.
 > >  
 > > Indeed.  Mark/Andreas, want to send me a new patch against latest
 > > Linus HEAD ?  I didn't apply the old one yet, as it conflicted with
 > > the changes already queued for merging.
 > 
 > This is against -git7.  I should think that's close enough.

So close!

arch/x86/kernel/cpu/cpufreq/powernow-k8.c: In function ‘powernowk8_target’:
arch/x86/kernel/cpu/cpufreq/powernow-k8.c:1054: error: ‘struct powernow_k8_data’ has no member named ‘currdid’
make[1]: *** [arch/x86/kernel/cpu/cpufreq/powernow-k8.o] Error 1
make: *** [arch/x86/kernel/cpu/cpufreq/powernow-k8.o] Error 2

Missed one of the conversions?

	Dave

-- 
http://www.codemonkey.org.uk
