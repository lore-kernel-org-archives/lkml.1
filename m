Return-Path: <linux-kernel-owner+w=401wt.eu-S932796AbXCKDQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796AbXCKDQg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 22:16:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932805AbXCKDQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 22:16:36 -0500
Received: from smtp.osdl.org ([65.172.181.24]:34896 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932796AbXCKDQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 22:16:34 -0500
Date: Sat, 10 Mar 2007 19:16:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Con Kolivas" <kernel@kolivas.org>
Cc: mpm@selenic.com, linux-kernel@vger.kernel.org, ck@vds.kolivas.org
Subject: Re: RSDL-mm 0.28
Message-Id: <20070310191614.5ac3cf4b.akpm@linux-foundation.org>
In-Reply-To: <8cd998d50703101828l71fbec7bi9a819ad7b7fd9828@mail.gmail.com>
References: <20070311013506.GD10459@waste.org>
	<8cd998d50703101828l71fbec7bi9a819ad7b7fd9828@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 11 Mar 2007 13:28:22 +1100 "Con Kolivas" <kernel@kolivas.org> wrote:
> Well... are you advocating we change sched_yield semantics to a
> gentler form?

>From a practical POV: our present yield() behaviour is so truly awful that
it's basically always a bug to use it.  This probably isn't a good thing.

So yes, I do think that we should have a rethink and try to come up with
behaviour which is more in accord with what application developers expect
yield() to do.

otoh,

a) we should have done this five years ago.  Instead, we've spent that
   time training userspace programmers to not use yield(), so perhaps
   there's little to be gained in changing it now.

b) if we _were_ to change yield(), people would use it more, and their
   applications would of course suck bigtime when run on earlier 2.6
   kernels.


Bottom line: we've had a _lot_ of problems with the new yield() semantics. 
We effectively broke back-compatibility by changing its behaviour a lot,
and we can't really turn around and blame application developers for that.

