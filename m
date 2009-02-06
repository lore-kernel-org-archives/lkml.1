Return-Path: <linux-kernel-owner+w=401wt.eu-S1758805AbZBFPqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbZBFPqB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 10:46:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbZBFPpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 10:45:53 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:18525 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699AbZBFPpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 10:45:52 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>
In-Reply-To: <1233934150.20597.26.camel@zakaz.uk.xensource.com>
References: <patchbomb.1233862242@abulafia.goop.org>
	 <ab45a6865df539a36a75.1233862277@abulafia.goop.org>
	 <1233934150.20597.26.camel@zakaz.uk.xensource.com>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 15:45:01 +0000
Message-Id: <1233935101.20597.28.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH 35 of 36] x86: make pgd/pud/pmd/pte_none consistent
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=NkRAZMAOj8gA:10 a=x2RMdOTEVusA:10 a=7QJnBGmzxH6UZBSdJk4A:9 a=TuIEQKtVA0vH2HvDnEvMuqz7GzIA:4 a=LY0hPdMaydYA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-06 at 15:29 +0000, Ian Campbell wrote:
> On Thu, 2009-02-05 at 11:31 -0800, Jeremy Fitzhardinge wrote:
> > The _none test is done differently for every level of the pagetable.
> > Standardize them by:
> > 
> >  1: Use the native_X_val to extract the raw entry, with no need to go
> >     via paravirt_ops, diff -r 1d0646d0d319 arch/x86/include/asm/pgtable.h, and
> >  2: Compare with 0 rather than using a boolean !, since they are actually values
> >     and not booleans.
> 
> In a 32 bit Xen guest this one causes
> 
>         [    8.354898] 1 multicall(s) failed: cpu 1

Spoke too soon, it's not as 100% reliably reproducing as I thought which
confused my bisection attempt. Will try and locate the real culprit...

Ian.

-- 
Ian Campbell

For a man to truly understand rejection, he must first be ignored by a cat.

