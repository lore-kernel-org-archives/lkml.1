Return-Path: <linux-kernel-owner+w=401wt.eu-S1758885AbXJXRFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885AbXJXRFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932180AbXJXREt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:04:49 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41802 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932174AbXJXREr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:04:47 -0400
Date: Wed, 24 Oct 2007 10:04:41 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Gautham R Shenoy <ego@in.ibm.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russel <rusty@rustcorp.com.au>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Paul E McKenney <paulmck@us.ibm.com>,
       Richard Gooch <rgooch@atnf.csiro.au>,
       Tigran Aivazian <tigran@aivazian.fs.co.uk>,
       Shoahua Li <shaohua.li@linux.com>, Ralf Baechle <ralf@linux-mips.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Nathan Lynch <ntl@pobox.com>, David Miller <davem@davemloft.net>,
       Paul Jackson <pj@sgi.com>, Josh Triplett <josh@freedesktop.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [RFC PATCH 0/5] Refcount based Cpu Hotplug. V2
In-Reply-To: <20071024052931.GA22722@in.ibm.com>
Message-ID: <Pine.LNX.4.64.0710241001160.26202@schroedinger.engr.sgi.com>
References: <20071024052931.GA22722@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007, Gautham R Shenoy wrote:

> This is the version 2 of the refcount based cpu-hotplug "locking" 
> implementation. 

Uggh. This introduces a global lock that has to be taken always when 
scanning over cpus? Is multipe cpus are scanning over processor lists then 
we will get into scaling problems. Wasnt there an RCU based implementation 
that avoided cacheline bouncing and refcounting?

> The patchstack which is based against 2.6.23-mm1 has behaved well
> when it was stress tested with kernbench running while continuously
> performing cpu-hotplug operations on i386, x86_64 and ppc64.

What was the highest cpu count in testing?
