Return-Path: <linux-kernel-owner+w=401wt.eu-S935211AbXGQWUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935211AbXGQWUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 18:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759413AbXGQWU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 18:20:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60572 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759390AbXGQWU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 18:20:26 -0400
Date: Tue, 17 Jul 2007 15:19:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Jeff Garzik <jgarzik@redhat.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       chas@cmf.nrl.navy.mil, rolandd@cisco.com, dwmw2@infradead.org,
       gregkh@suse.de
Subject: Re: [git patches 1/2] warnings: attack valid cases spotted by
 warnings
Message-Id: <20070717151906.27208ebf.akpm@linux-foundation.org>
In-Reply-To: <ada8x9epuip.fsf@cisco.com>
References: <20070717214239.GF28448@devserv.devel.redhat.com>
	<ada8x9epuip.fsf@cisco.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007 14:53:02 -0700
Roland Dreier <rdreier@cisco.com> wrote:

> >     drivers/infiniband/hw/mthca/mthca_qp: kill uninit'd var warning
> >     
> >     drivers/infiniband/hw/mthca/mthca_qp.c: In function
> >       ______mthca_tavor_post_send______:
> >     drivers/infiniband/hw/mthca/mthca_qp.c:1594: warning: ______f0______ may be used
> >       uninitialized in this function

(rofl, look at that mess: it was utterly impractical, unrealistic and
stupid for gcc to go and UTFify the compiler output.  Sigh.  LANG=C, guys).

> And I don't like using uninitialized_var() here for a similar
> reason... the functions are complex and I would prefer to avoid hiding
> future bugs that may creep in. 

umm, the code *already* produces a warning.  So if you later add a
real used-uninitialised bug, you won't know about it, because everyone
was trained to ignore the warning anyway.

Best would be to find some way to restructure the code to make the warning
go away.

Meanwhile I'd say switch this to uninitialized_var() if it's that much of a
worry.

