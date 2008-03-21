Return-Path: <linux-kernel-owner+w=401wt.eu-S1760566AbYCURnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760566AbYCURnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 13:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757005AbYCURni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 13:43:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753396AbYCURnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 13:43:37 -0400
Date: Fri, 21 Mar 2008 10:41:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, davej@redhat.com,
       sam@ravnborg.org, greg@kroah.com, randy.dunlap@oracle.com
Subject: Re: [PATCH 5/7] PPS: serial clients support.
Message-Id: <20080321104125.e1ff69c5.akpm@linux-foundation.org>
In-Reply-To: <20080321111736.GC8959@enneenne.com>
References: <12048053463198-git-send-email-giometti@linux.it>
	<12048053473401-git-send-email-giometti@linux.it>
	<12048053471754-git-send-email-giometti@linux.it>
	<12048053471177-git-send-email-giometti@linux.it>
	<12048053473741-git-send-email-giometti@linux.it>
	<12048053472063-git-send-email-giometti@linux.it>
	<20080320130400.0b17e1fc.akpm@linux-foundation.org>
	<20080321111736.GC8959@enneenne.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008 12:17:36 +0100 Rodolfo Giometti <giometti@enneenne.com> wrote:

> > > +#else
> > > +
> > > +#define uart_register_pps_port(state, port)	do { } while (0)
> > > +#define uart_unregister_pps_port(state, port)	do { } while (0)
> > 
> > Please never implement in cpp that which can be implemented in C.  These
> > should have been static inlines.  That's nicer, matches the
> > CONFIG_PPS_CLIENT_UART=y code and provides type checking.
> 
> Are you saying that I should do:
> 
> static inline int
> uart_register_pps_port(struct uart_state *state, struct uart_port *port)
> {
> 	/* Nop */
> }
> 
> static inline void
> uart_unregister_pps_port(struct uart_state *state, struct uart_port *port)
> {
> 	/* Nop */
> }
> 
> ?

Yes please.
