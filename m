Return-Path: <linux-kernel-owner+w=401wt.eu-S939050AbXHLVCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939050AbXHLVCb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 17:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938670AbXHLVCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 17:02:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46621 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938935AbXHLVCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 17:02:11 -0400
Subject: Re: [patch 0/8] Immediate Values
From: Arjan van de Ven <arjan@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070812185501.GA4480@Krystal>
References: <20070812150702.769065566@polymtl.ca>
	 <1186943243.2854.17.camel@laptopd505.fenrus.org>
	 <20070812185501.GA4480@Krystal>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 12 Aug 2007 13:58:44 -0700
Message-Id: <1186952324.2854.21.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 (2.11.6.1-1.fc8) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > I have a concern; you seem to be patching potentially "live" code....
> > 
> > there are basically two options
> > 1) you run the risk of triple faulting (patching an instruction while
> > some other core/cpu may be decoding it may cause a triple fault)
> > 2) you do an IPI to all other cpus and prevent them from executing any
> > code except a small loop during the patching... this is expensive.
> > 
> > To be honest, neither sound very attractive to me ;(
> > 
> 
> Yup, the concern is appropriate. That's why I dealt with it in the
> "Immediate Values - i386 Optimization" patch. (I guess your concern
> is specific to i386, x86_64 and ia64).

it's specific to all smp architectures I suppose
> 
> I have currently only implemented the i386 optimization, but x86_64 and
> ia64 should be similar.
> 
> The triple fault in question is discussed in Intel's errata under the
> title "Centrino Duo Processor Technology Specification Update, AH33.
> Unsynchronized Cross-Modifying Code Operations Can Cause Unexpected
> Instruction Execution Results." (if you refer to something else, please
> tell me).

Core2DUO is only one generation of Intel processors; however I know that
several other (if not all of them) have issues with this kind of thing
in ring 0; all subtly different ;(

All other alternatives are ok right now (they all run in UP mode),
but... I'm just very nervous about the amount of CPU errata in this kind
of scenario. And I'm not just talking Intel, I wouldn't be surprised if
the other x86 CPU vendors also have issues with this; I don't know how
well they specify their errata though..


-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

