Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbZHZLiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbZHZLiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 07:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756297AbZHZLiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 07:38:10 -0400
Received: from viefep15-int.chello.at ([62.179.121.35]:12645 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940AbZHZLiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 07:38:09 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [v2 PATCH 2/2]: pseries: Implement Pseries Processor Idle idle
 module.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: arun@linux.vnet.ibm.com
Cc: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <20090826113217.GA14758@linux.vnet.ibm.com>
References: <20090826110721.GA29759@linux.vnet.ibm.com>
	 <20090826111003.GC29759@linux.vnet.ibm.com> <1251286038.1329.1.camel@twins>
	 <20090826113217.GA14758@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 26 Aug 2009 13:37:05 +0200
Message-Id: <1251286625.1329.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 17:02 +0530, Arun R Bharadwaj wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-08-26 13:27:18]:
> 
> > On Wed, 2009-08-26 at 16:40 +0530, Arun R Bharadwaj wrote:
> > > +void (*pm_idle)(void);
> > > +EXPORT_SYMBOL_GPL(pm_idle);
> > 
> > Seriously.. this caused plenty problems over on x86 and you're doing the
> > exact same dumb thing?
> > 
> 
> Hi Peter,
> 
> Cpuidle assumes pm_idle to be the default idle power management
> function. So i should either do this, or change the stuff in cpuidle.c
> so that it is more abstract.

I would much prefer the latter, I've been telling the x86 power folks to
fix this like forever, but they never seem to get around to it.

They even tried adding a second such unmanaged function pointer for
play-dead, instead of integrating everything into a single management
interface.

