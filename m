Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880Ab0CMMfY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 07:35:24 -0500
Received: from www84.your-server.de ([213.133.104.84]:54123 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758156Ab0CMMfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 07:35:23 -0500
Subject: Re: [Patch] fix MTD CFI/LPDDR flash driver huge latency bug
From: Stefani Seibold <stefani@seibold.net>
To: Jamie Lokier <jamie@shareable.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       "Kreuzer, Michael (NSN - DE/Ulm)" <michael.kreuzer@nsn.com>,
       linux-mtd@lists.infradead.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100312233820.GH6491@shareable.org>
References: <1267894137.18869.0.camel@wall-e>
	 <20100312142344.174bd46f.akpm@linux-foundation.org>
	 <20100312233820.GH6491@shareable.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 13 Mar 2010 13:35:44 +0100
Message-ID: <1268483744.6339.25.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 12.03.2010, 23:38 +0000 schrieb Jamie Lokier:
> Andrew Morton wrote:
> > On Sat, 06 Mar 2010 17:48:57 +0100
> > Stefani Seibold <stefani@seibold.net> wrote:
> > 


> > > The patch change all the use of spin_lock operations for xxxx->mutex
> > > into mutex operations, which is exact what the name says and means.
> 
> It would be even better if it also split the critical sections into
> smaller ones with cond_resched() between, so that non-preemptible
> kernels benefit too.
> 

The problem is the memcpy operation which is very slow. A cond_resched
wouldn't help, since the cpu bus is blocked during the transfer of the
word.



