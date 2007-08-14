Return-Path: <linux-kernel-owner+w=401wt.eu-S1760070AbXHNWps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760070AbXHNWps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932423AbXHNWpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:45:33 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:39455 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932317AbXHNWpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:45:30 -0400
Date: Tue, 14 Aug 2007 15:45:28 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Chris Snook <csnook@redhat.com>
cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       Segher Boessenkool <segher@kernel.crashing.org>,
       "Luck, Tony" <tony.luck@intel.com>, Chris Friesen <cfriesen@nortel.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH 1/23] document preferred use of volatile with atomic_t
In-Reply-To: <20070813110415.GA24018@shell.boston.redhat.com>
Message-ID: <Pine.LNX.4.64.0708141544001.401@schroedinger.engr.sgi.com>
References: <46C03885.7000109@redhat.com> <20070813110415.GA24018@shell.boston.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007, Chris Snook wrote:

> @@ -38,7 +45,7 @@
>  
>  Next, we have:
>  
> -	#define atomic_read(v)	((v)->counter)
> +	#define atomic_read(v)	(*(volatile int *)&(v)->counter)
>  
>  which simply reads the current value of the counter.

volatile means that there is some vague notion of "read it now". But that 
really does not exist. Instead we control visibility via barriers 
(smp_wmb, smp_rmb). Would it not be best to not have volatile at all in 
atomic operations and let the barriers do the work?

