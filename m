Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbXDSXBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbXDSXBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 19:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbXDSXBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 19:01:04 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754291AbXDSXBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 19:01:03 -0400
Date: Thu, 19 Apr 2007 15:59:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Simon Horman <horms@verge.net.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, Wensong Zhang <wensong@linux-vs.org>,
       Julian Anastasov <ja@ssi.bg>
Subject: Re: [PATCH] ipv4/ipvs: Convert to kthread API
Message-Id: <20070419155944.e5fb8e66.akpm@linux-foundation.org>
In-Reply-To: <20070419090435.GB26050@verge.net.au>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<11769696262330-git-send-email-ebiederm@xmission.com>
	<20070419090435.GB26050@verge.net.au>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 18:04:36 +0900
Simon Horman <horms@verge.net.au> wrote:

> On Thu, Apr 19, 2007 at 01:58:57AM -0600, Eric W. Biederman wrote:
> > From: Eric W. Biederman <ebiederm@xmission.com>
> > 
> > Modify startup of ipvs sync threads to use kthread_run
> > instead of a weird combination of calling kernel_thread
> > to start a fork_sync_thread whose hole purpose in life was
> > to call kernel_thread again starting the actually sync thread
> > which called daemonize.
> > 
> > To use kthread_run I had to move the name calcuation from
> > sync_thread into start_sync_thread resulting in a small
> > amount of code motion.
> > 
> > The result is simpler and more maintainable piece of code.
> 
> Thanks Eric, I'll review this and get back to you shortly.
> 

There still seems to be quite a lot of complexity in this driver's
thread handling which could be removed if we did a full conversion 
to the kthread API.

It all looks.... surprisingly complex in there.
