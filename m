Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbZFSAqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbZFSAqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 20:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbZFSAqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 20:46:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:34079 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbZFSAqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 20:46:32 -0400
Subject: Re: [PATCH 1/2] lib: Provide generic atomic64_t implementation
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <8bd0f97a0906181655jd68835fg10fe0783b6a6068d@mail.gmail.com>
References: <18995.20685.227683.561827@cargo.ozlabs.ibm.com>
	 <8bd0f97a0906181655jd68835fg10fe0783b6a6068d@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 19 Jun 2009 10:46:14 +1000
Message-Id: <1245372374.16880.0.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-18 at 19:55 -0400, Mike Frysinger wrote:
> On Sat, Jun 13, 2009 at 03:10, Paul Mackerras wrote:
> > +typedef struct {
> > +       long long counter;
> > +} atomic64_t;
> 
> lack of volatile seems odd compared to:
> include/linux/types.h:
> typedef struct {
>     volatile int counter;
> } atomic_t;

Since the counter is only accessed within a spinlock, the volatile
wouldn't be very useful here.

Cheers,
Ben.


