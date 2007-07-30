Return-Path: <linux-kernel-owner+w=401wt.eu-S939846AbXG3X5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939846AbXG3X5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 19:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765676AbXG3X5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 19:57:00 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:47269 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763101AbXG3X47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 19:56:59 -0400
Date: Mon, 30 Jul 2007 16:56:45 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use ERESTARTNOHAND if poll() is interrupted by a signal
Message-ID: <20070730235645.GN3672@sequoia.sous-sol.org>
References: <200707291705.l6TH554a003344@colorfullife.mysite.adiungo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707291705.l6TH554a003344@colorfullife.mysite.adiungo.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Manfred Spraul (manfred@colorfullife.com) wrote:
> poll() returns -EINTR if a signal is pending.
> EINTR is a bad choice: it means that poll returns to user space if the
> task is stopped by SIGSTOP/SIGCONT or by the freezer.
> select() and ppoll() both use ERESTARTNOHAND, this avoids a return to
> user space for signals that are handled by the kernel.

This does change user visible behaviour, however, it's already
inconsistent as you've noted.  I was concerned about that change, but
wrote some tests and this behaviour does make sense to me.

thanks,
-chris
