Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbZGUCeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbZGUCeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 22:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661AbZGUCeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 22:34:04 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:36237 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470AbZGUCeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 22:34:03 -0400
Subject: Re: [PATCH 05/06] Fix compilation warning for
	arch/x86/kernel/apm_32.c
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-laptop@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@redhat.com>, David Howells <dhowells@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090718141322.GI32618@elte.hu>
References: <20090715022038.4374.74212.sendpatchset@subratamodak.linux.ibm.com>
	 <20090718141322.GI32618@elte.hu>
Content-Type: text/plain
Organization: IBM
Date: Tue, 21 Jul 2009 08:03:55 +0530
Message-Id: <1248143636.9140.4.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-18 at 16:13 +0200, Ingo Molnar wrote:
> * Subrata Modak <subrata@linux.vnet.ibm.com> wrote:
> 
> > Following fix is inspired by David Howells fix few days back:
> > http://lkml.org/lkml/2009/7/9/109,
> > 
> > Signed-off-by: Subrata Modak<subrata@linux.vnet.ibm.com>,
> > ---
> > 
> > --- a/arch/x86/kernel/apm_32.c	2009-06-15 07:50:51.000000000 +0530
> > +++ b/arch/x86/kernel/apm_32.c	2009-07-15 06:43:59.000000000 +0530
> > @@ -811,7 +811,7 @@ static int apm_do_idle(void)
> >  	u8 ret = 0;
> >  	int idled = 0;
> >  	int polling;
> > -	int err;
> > +	int uninitialized_var(err);
> 
> Please dont use uninitialized_var() as it's dangerous - in something 
> as performance-uncritical as this we should initialize it to 0 and 
> mention it in the changelog that this works around a GCC false 
> positive warning.

Sure. Resending as you suggested.

Regards--
Subrata

> 
> Thanks,
> 
> 	Ingo

