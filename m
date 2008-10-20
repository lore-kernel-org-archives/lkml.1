Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbYJTGxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbYJTGxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 02:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbYJTGw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 02:52:59 -0400
Received: from bender.cm4all.net ([87.106.27.49]:34055 "EHLO bender.cm4all.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbYJTGw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 02:52:58 -0400
Date: Mon, 20 Oct 2008 08:51:49 +0200
From: Max Kellermann <mk@cm4all.com>
To: Glauber Costa <glommer@redhat.com>
Cc: linux-kernel@vger.kernel.org, ijc@hellion.org.uk,
       Grant Coady <grant_lkml@dodo.com.au>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Tom Tucker <tom@opengridcomputing.com>
Subject: Re: [PATCH] NFS regression in 2.6.26?, "task blocked for more than 120 seconds"
Message-ID: <20081020065149.GA11213@rabbit.intern.cm-ag>
References: <20081017123207.GA14979@rabbit.intern.cm-ag> <20081017143301.GA18522@poweredge.glommer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017143301.GA18522@poweredge.glommer>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008/10/17 16:33, Glauber Costa <glommer@redhat.com> wrote:
> That's probably something related to apic congestion.
> Does the problem go away if the only thing you change is this:
> 
> 
> > @@ -891,11 +897,6 @@ do_rest:
> >  		store_NMI_vector(&nmi_high, &nmi_low);
> >  
> >  		smpboot_setup_warm_reset_vector(start_ip);
> > -		/*
> > -		 * Be paranoid about clearing APIC errors.
> > -	 	*/
> > -		apic_write(APIC_ESR, 0);
> > -		apic_read(APIC_ESR);
> >  	}
> 
> 
> Please let me know.

Hello Glauber,

I have rebooted the server with 2.6.27.1 + this patchlet an hour ago.
No problems since.

Hardware: Compaq P4 Xeon server, Broadcom CMIC-WS / CIOB-X2 board.
Tell me if you need more detailed information.


On 2008/10/20 08:27, Ian Campbell <ijc@hellion.org.uk> wrote:
> The issue I see still occurs well before those changesets. I have
> seen it with v2.6.25 but v2.6.24 survived for 7 days without issue
> (my threshold for a good kernel is 7 days, hence bisecting is a bit
> slow...).

Hello Ian,

it seems we're hunting down different bugs after all.  Too bad, I
hoped I could have solved your problem, too.  Our machine has been
running well over the weekend with the patch I posted; with faulty
kernels, the problem would occur after a few minutes.

Max
