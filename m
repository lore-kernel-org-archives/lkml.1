Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbYJBQmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbYJBQmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 12:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbYJBQmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 12:42:32 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:50172 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933AbYJBQmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 12:42:32 -0400
Date: Thu, 2 Oct 2008 18:42:11 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081002164211.GK19428@kernel.dk>
References: <20081001215638.3a65134c.akpm@linux-foundation.org> <87fxnfpjqj.fsf@basil.nowhere.org> <20081002075511.GX19428@kernel.dk> <20081002093326.GF30001@disturbed> <20081002094537.GA19428@kernel.dk> <20081002061433.4e995075@infradead.org> <20081002132746.GG19428@kernel.dk> <20081002063606.512decb3@infradead.org> <20081002134736.GH19428@kernel.dk> <20081002072650.248373ea@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002072650.248373ea@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02 2008, Arjan van de Ven wrote:
> On Thu, 2 Oct 2008 15:47:37 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > Yes, it'll report '0' which means 'not set'. The kernel inteprets 'not
> > set' as the default values, BE/4. There's a big diffence, since '0'
> > means that we track CPU nice values where as if it returned be/4 then
> > that is a strict/fixed setting.
> 
> argh. "0" means both "not set" and "highest priority".

Arjan, please read the interface, it does not...

0 means not set, period. What matters is the class setting, if that is
non-zero then it is a valid setting. See

#define IOPRIO_PRIO_VALUE(class, data)  (((class) << IOPRIO_CLASS_SHIFT) | data)

So highest priority BE is IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, 0), which
is of course valid.

-- 
Jens Axboe

