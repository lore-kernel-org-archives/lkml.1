Return-Path: <linux-kernel-owner+w=401wt.eu-S1756276AbYDLSUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbYDLSUU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 14:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbYDLSUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 14:20:04 -0400
Received: from ozlabs.org ([203.10.76.45]:41004 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387AbYDLSUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 14:20:03 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH RFC 1/5] vringfd syscall
Date: Sun, 13 Apr 2008 04:19:54 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Max Krasnyansky <maxk@qualcomm.com>,
       virtualization@lists.linux-foundation.org
References: <200804052202.09157.rusty@rustcorp.com.au> <20080412171820.GA29568@dmt>
In-Reply-To: <20080412171820.GA29568@dmt>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804130419.55083.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 April 2008 03:18:20 Marcelo Tosatti wrote:
> I suppose you are doing data copy in ->poll instead of ->read to save
> a system call? This is weird, not conformant to what the interface is
> supposed to do.

Hi Marcelo,

   Thanks for reading this.

   Yeah, I dislike it too.  The main motivation was that not all rings need to 
be "pulled" in this way, but it turns out that userspace can detect this 
(poll, check ring, if nothing, try read, check ring).  So next version will 
unscrew the poll callback.

> > +	/* If they want to use atomically, we have to map the page. */
> > +	if (atomic_use) {
> > +		if (get_user_pages(current, current->mm,
> > +				   (unsigned long)vr->ring.used, 1, 1, 1,
> > +				   &vr->used_page, NULL) != 1) {
>
> Can't the same be achieved by the app mlocking the vring pages, which
> then goes through standard rlimit checking ?

Tun/tap writes to this from any context.  Fortunately, this too is changing, 
as I came up with a sane way of queueing to userspace context for this case.

Expect updated patches Monday.

Thanks!
Rusty.
