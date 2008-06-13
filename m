Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbYFMOWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbYFMOWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 10:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbYFMOWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 10:22:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbYFMOWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 10:22:02 -0400
Subject: Re: [PATCH] firewire: fill_bus_reset_event needs lock protection
From: Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@redhat.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.c85eeaa74264184c@s5r6.in-berlin.de>
References: <tkrat.c85eeaa74264184c@s5r6.in-berlin.de>
Content-Type: text/plain; charset=utf8
Date: Fri, 13 Jun 2008 10:21:38 -0400
Message-Id: <1213366898.25956.0.camel@gaara.bos.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 (2.22.0-4.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-06 at 22:11 +0200, Stefan Richter wrote:
> Callers of fill_bus_reset_event() have to take card->lock.  Otherwise
> access to node data may oops if node removal is in progress.
> 
> A lockless alternative would be
> 
> -	event->local_node_id = card->local_node->node_id;
> +	tmp = fw_node_get(card->local_node);
> +	event->local_node_id = tmp->node_id;
> +	fw_node_put(tmp);
> 
> and ditto with the other node pointers which fill_bus_reset_event()
> accesses.  But I went the locked route because one of the two callers
> already holds the lock.  As a bonus, we don't need the memory barrier
> anymore because device->generation and device->node_id are written in
> a card->lock protected section.

Looks good to me.

Signed-off-by: Kristian Høgsberg <krh@redhat.com>


