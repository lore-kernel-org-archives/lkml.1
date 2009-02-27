Return-Path: <linux-kernel-owner+w=401wt.eu-S1760473AbZB0VXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760473AbZB0VXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 16:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757934AbZB0VXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 16:23:37 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:51353 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757710AbZB0VXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 16:23:37 -0500
Subject: Re: [RFC][PATCH 2/8] breakout fdinfo sprintf() into its own
	function
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       hch@infradead.org, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <19f34abd0902271256r49a06336rcba56234c06645a7@mail.gmail.com>
References: <20090227203425.F3B51176@kernel>
	 <20090227203426.9F73083F@kernel>
	 <19f34abd0902271256r49a06336rcba56234c06645a7@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 27 Feb 2009 13:23:33 -0800
Message-Id: <1235769813.26788.391.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-27 at 21:56 +0100, Vegard Nossum wrote:
> > +static void proc_fd_write_info(struct file *file, char *info)
> > +{
> > +       int max = PROC_FDINFO_MAX;
> > +       int p = 0;
> > +       if (!info)
> > +               return;
> > +
> > +       p += snprintf(info+p, max-p, "pos:\t%lli\n", (long long) file->f_pos);
> > +       p += snprintf(info+p, max-p, "flags:\t0%o\n", file->f_flags);
> 
> Actually, snprintf() is not the right function to use here.
> scnprintf(), perhaps?

Yes, that does look more appropriate.  I'll double-check what happens
when we overrun the buffer.

-- Dave

