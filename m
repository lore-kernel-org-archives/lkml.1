Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbYIYHZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbYIYHZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 03:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYIYHZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 03:25:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:36003 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbYIYHZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 03:25:46 -0400
Subject: Re: [PATCH HACK] powerpc: quick hack to get a functional eHEA with
	hardirq preemption
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: Milton Miller <miltonm@bga.com>, Jan-Bernd Themann <ossthema@de.ibm.com>,
       Christoph Raisch <RAISCH@de.ibm.com>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080925091827.29b5087c@bull.net>
References: <200809231743.23828.ossthema@de.ibm.com>
	 <20080915100406.342e027a@bull.net>
	 <200809240958.m8O9wM7k010996@sullivan.realtime.net>
	 <1222251467.8277.73.camel@pasglop> <20080924143552.29a14f10@bull.net>
	 <1222290917.8277.83.camel@pasglop>  <20080925091827.29b5087c@bull.net>
Content-Type: text/plain
Date: Thu, 25 Sep 2008 17:22:41 +1000
Message-Id: <1222327361.8277.179.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-25 at 09:18 +0200, Sebastien Dugue wrote:
> 
> > Ok, that's the right approach then. It should work. I don't know
> what
> > the specific problems with HEA are at this stage.
> 
>   Yep, except as it behaves in way that the current -rt fasteoi flow
> cannot handle.

We probably need to make a special xics flow handler for -rt that does
what Milton suggested, ie, bring down the CPU priority right away and
only EOI later or something like that, instead of masking/unmasking.

I don't know what are the other potential issues with the HEA though.

Ben.


