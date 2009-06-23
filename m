Return-Path: <linux-kernel-owner+w=401wt.eu-S1754318AbZFWBRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbZFWBRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 21:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbZFWBRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 21:17:07 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56027 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751313AbZFWBRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 21:17:05 -0400
Subject: Re: [PATCH] mm/init: cpu_hotplug_init() must be initialized before
 SLAB
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Sachin Sant <sachinp@in.ibm.com>
In-Reply-To: <1245717089.4017.18.camel@pasglop>
References: <1245717089.4017.18.camel@pasglop>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 20:13:08 -0500
Message-Id: <1245719588.17035.42.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 10:31 +1000, Benjamin Herrenschmidt wrote:
> SLAB uses get/put_online_cpus() which use a mutex which is itself
> only initialized when cpu_hotplug_init() is called. Currently
> we hang suring boot in SLAB due to doing that too late. This
> moves the call to cpu_hotplug_init() to before mm_init() (it
> should be safe to call that early).
> 
> This fixes boot with SLAB on some PowerPC machines.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
> Sachin, James, do that fix the boot failures you've been seeing ?

Yes, that seems to fix it for me.

James


