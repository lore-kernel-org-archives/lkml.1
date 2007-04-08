Return-Path: <linux-kernel-owner+w=401wt.eu-S1751025AbXDHKWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751025AbXDHKWl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 06:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbXDHKWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 06:22:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53594 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbXDHKWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 06:22:40 -0400
Date: Sun, 8 Apr 2007 11:22:31 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, srinivasa@in.ibm.com,
       akpm@linux-foundation.org,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       hch@infradead.org, davem@davemloft.net, richardj_moore@uk.ibm.com
Subject: Re: [RFC][PATCH] Kprobes: The ON/OFF knob thru debugfs
Message-ID: <20070408102231.GA2297@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
	lkml <linux-kernel@vger.kernel.org>,
	Prasanna S Panchamukhi <prasanna@in.ibm.com>,
	Jim Keniston <jkenisto@us.ibm.com>, srinivasa@in.ibm.com,
	akpm@linux-foundation.org,
	Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	davem@davemloft.net, richardj_moore@uk.ibm.com
References: <20070404121349.GA26313@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404121349.GA26313@in.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 05:43:49PM +0530, Ananth N Mavinakayanahalli wrote:
> This patch provides a debugfs knob to turn kprobes on/off
> 
> o A new file /debug/kprobes/enabled indicates if kprobes is enabled or
>   not (default enabled)
> o Echoing 0 to this file will disarm all installed probes
> o Any new probe registration when disabled will register the probe but
>   not arm it. A message will be printed out in such a case.
> o When a value 1 is echoed to the file, all probes (including ones
>   registered in the intervening period) will be enabled
> o Unregistration will happen irrespective of whether probes are globally
>   enabled or not.
> o Update Documentation/kprobes.txt to reflect these changes. While there
>   also update the doc to make it current.

Looks good.

When I suggested a user interface to enable/disable probes was nice to
have I was more thinking about a interface to enable/disable individual
probes.  Any chance you could try to implement that aswell as see if
any code can be shared with this feature?

> -	arch_arm_kprobe(p);
> +		arch_arm_kprobe(p);
> +	} else
> +		printk("Kprobes are globally disabled. This kprobe [@ %p] "
> +			"will be enabled with all other probes\n", p->addr);

This printk seems far too verbose.  Just remove it and make sure
the debugfs interface has an indicator of whether probes are en- or
disabled.

