Return-Path: <linux-kernel-owner+w=401wt.eu-S1752455AbYCPMU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbYCPMU2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 08:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbYCPMUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 08:20:19 -0400
Received: from www.tglx.de ([62.245.132.106]:41199 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbYCPMUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 08:20:18 -0400
Date: Sun, 16 Mar 2008 13:20:08 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Cc: "Jean-Samuel Chenard" <jsamch@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, "Greg KH" <greg@kroah.com>,
       grant.likely@secretlab.ca,
       "Juergen Beisert" <juergen127@kreuzholzen.de>
Subject: Re: Linux UIO driver cache problem in PowerPC (fix)
Message-ID: <20080316132008.5050153d@bluebox.local>
In-Reply-To: <c384c5ea0803151951g47bd5214j18334f03f95821fe@mail.gmail.com>
References: <169c03cb0803121222h5fca9cdal5af873cd2a700f4d@mail.gmail.com>
	<20080313081932.4edee290@dilbert.local>
	<20080314113336.63af1e7a@bluebox.local>
	<c384c5ea0803151951g47bd5214j18334f03f95821fe@mail.gmail.com>
Organization: Linutronix GmbH
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sun, 16 Mar 2008 03:51:10 +0100
schrieb "Leon Woestenberg" <leon.woestenberg@gmail.com>:

> Hello,
> 
> On Fri, Mar 14, 2008 at 11:33 AM, Hans J. Koch <hjk@linutronix.de>
> wrote:
> >  I investigated a bit and found your patch to be correct. I cleaned
> > it up a bit and sent it to Greg and LKML. I added you as author
> > and also took the freedom to add your Signed-off-by.
> >
> Could you elaborate why exactly this is needed, maybe even as a
> comment in the patch?

As far as I understood, the VM_IO flag simply means that the page is
used for IO. On some architectures this automatically means that the
page is not cached, but this is not guaranteed. That's why
pgprot_noncached() exists.

If I misunderstood something or somebody can explain it better, please
let me know.

> 
> It seemed non-trivial enough to rectify adding a comment.

It _is_ trivial. It's just something you don't need every day, and
therefore it's not known to everybody (including me) or not obvious.
But if you look at it:

VM_IO means IO
pgprot_noncached means noncached

What could be more trivial?

Thanks,
Hans
