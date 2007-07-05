Return-Path: <linux-kernel-owner+w=401wt.eu-S1760144AbXGEQCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760144AbXGEQCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 12:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756609AbXGEQCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 12:02:08 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41668 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901AbXGEQCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 12:02:06 -0400
Subject: Re: [RFC PATCH 4/6] relay: add relay_reserve_cpu()
From: Tom Zanussi <zanussi@us.ibm.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: linux-kernel@vger.kernel.org, dwilder@us.ibm.com, HOLZHEU@de.ibm.com
In-Reply-To: <20070704031738.GB24341@Krystal>
References: <1183173852.24291.140.camel@ubuntu>
	 <20070704031738.GB24341@Krystal>
Content-Type: text/plain
Date: Thu, 05 Jul 2007 11:00:35 -0500
Message-Id: <1183651235.4517.166.camel@ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-03 at 23:17 -0400, Mathieu Desnoyers wrote:
> * Tom Zanussi (zanussi@us.ibm.com) wrote:
> > This patch adds the ability to explicitly specify the per-cpu buffer
> > to reserve space in.  Needed for early DTI tracing.
> > 
> 
> This should come with the ability to tell relay where the already
> allocated static buffers are. Can you tell me a little more on why the
> standard relay_reserve would not do the job? Is smp_processor_id() not
> ready to output a sensible CPU id yet ?
> 

In the case of early tracing, the DTI code uses a global buffer and
saves the cpuid along with each event.  Later, when the relay channel is
available, the relogging code wants to put each event in the appropriate
per-cpu relay buffer.  The standard relay_reserve() always uses the
current cpuid, rather than the cpuid attached to the event, which is not
what we want.  relay_reserve_cpu() simply allows a cpuid other than the
current one to be used.

Tom




