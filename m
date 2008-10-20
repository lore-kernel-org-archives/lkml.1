Return-Path: <linux-kernel-owner+w=401wt.eu-S1752708AbYJTOVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbYJTOVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 10:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbYJTOVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 10:21:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:35441 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbYJTOVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 10:21:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UH/Kxzxd5SFlGxFuEhac8mpfftEcFaooWUw5x0/Jz16+ivyYLZ8GYGg4oWtBuBkD4A
         2+6LQ8oX6JVbeW8vKYKaAiW9Y//OAyvyFbphaCZInlviPrmsmY994KHFN8PaIApe/AS9
         04VPQPQO8KJqOWG8pthRFuw3QQINcUrEqVZxk=
Date: Mon, 20 Oct 2008 18:21:00 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Glauber Costa <glommer@gmail.com>
Cc: Max Kellermann <mk@cm4all.com>, Glauber Costa <glommer@redhat.com>,
       linux-kernel@vger.kernel.org, ijc@hellion.org.uk,
       Grant Coady <grant_lkml@dodo.com.au>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Tom Tucker <tom@opengridcomputing.com>
Subject: Re: [PATCH] NFS regression in 2.6.26?, "task blocked for more than
	120 seconds"
Message-ID: <20081020142100.GA25166@localhost>
References: <20081017123207.GA14979@rabbit.intern.cm-ag> <20081017143301.GA18522@poweredge.glommer> <20081020065149.GA11213@rabbit.intern.cm-ag> <5d6222a80810200615k60d6f523p9bcd71d8cb070a39@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d6222a80810200615k60d6f523p9bcd71d8cb070a39@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Glauber Costa - Mon, Oct 20, 2008 at 11:15:56AM -0200]
| On Mon, Oct 20, 2008 at 4:51 AM, Max Kellermann <mk@cm4all.com> wrote:
| > On 2008/10/17 16:33, Glauber Costa <glommer@redhat.com> wrote:
| >> That's probably something related to apic congestion.
| >> Does the problem go away if the only thing you change is this:
| >>
| >>
| >> > @@ -891,11 +897,6 @@ do_rest:
| >> >             store_NMI_vector(&nmi_high, &nmi_low);
| >> >
| >> >             smpboot_setup_warm_reset_vector(start_ip);
| >> > -           /*
| >> > -            * Be paranoid about clearing APIC errors.
| >> > -           */
| >> > -           apic_write(APIC_ESR, 0);
| >> > -           apic_read(APIC_ESR);
| >> >     }
| >>
| >>
| >> Please let me know.
| >
| > Hello Glauber,
| >
| > I have rebooted the server with 2.6.27.1 + this patchlet an hour ago.
| > No problems since.
| >
| > Hardware: Compaq P4 Xeon server, Broadcom CMIC-WS / CIOB-X2 board.
| > Tell me if you need more detailed information.
| >
| 
| There's a patch in flight from cyrill that probably fixes your problem:
| http://lkml.org/lkml/2008/9/15/93
| 
| The checks are obviously there for a reason, and we can't just wipe
| them out unconditionally ;-) So can you check please that you are also
| covered by the case provided?

Actually I'll wonder if it help. Do Xeon processors really not
have ESR register and not integrated?

...

		- Cyrill -
