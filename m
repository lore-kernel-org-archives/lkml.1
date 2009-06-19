Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbZFSAsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbZFSAsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 20:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbZFSArx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 20:47:53 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:37491 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbZFSArw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 20:47:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <19002.57382.880505.913539@cargo.ozlabs.ibm.com>
Date: Fri, 19 Jun 2009 10:47:34 +1000
From: Paul Mackerras <paulus@samba.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: benh@kernel.crashing.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] lib: Provide generic atomic64_t implementation
In-Reply-To: <8bd0f97a0906181655jd68835fg10fe0783b6a6068d@mail.gmail.com>
References: <18995.20685.227683.561827@cargo.ozlabs.ibm.com>
	<8bd0f97a0906181655jd68835fg10fe0783b6a6068d@mail.gmail.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger writes:

> On Sat, Jun 13, 2009 at 03:10, Paul Mackerras wrote:
> > +typedef struct {
> > +       long long counter;
> > +} atomic64_t;
> 
> lack of volatile seems odd compared to:
> include/linux/types.h:
> typedef struct {
>     volatile int counter;
> } atomic_t;
> -mike

It's only accessed under a spinlock, so I don't think it needs to be
volatile.  On UP it's accessed within local_irq_save/restore which
should also be compiler barriers and prevent memory access reordering,
so again volatile isn't needed.

Paul.
