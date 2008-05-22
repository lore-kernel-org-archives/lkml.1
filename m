Return-Path: <linux-kernel-owner+w=401wt.eu-S1755651AbYEVUTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbYEVUTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756270AbYEVUSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:18:47 -0400
Received: from www.tglx.de ([62.245.132.106]:36199 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755914AbYEVUSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:18:45 -0400
Date: Thu, 22 May 2008 22:18:29 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       lethal@linux-sh.org, hjk@linutronix.de, gregkh@suse.de,
       Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
Subject: Re: [PATCH 01/03] uio: Add enable_irq() callback
Message-ID: <20080522201829.GE3226@local>
References: <20080520105132.1474.73941.sendpatchset@rx1.opensource.se> <20080520105140.1474.59715.sendpatchset@rx1.opensource.se> <aec7e5c30805210458m3d15b89am563e4a94b8eb6f2c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aec7e5c30805210458m3d15b89am563e4a94b8eb6f2c@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 08:58:24PM +0900, Magnus Damm wrote:
> On Tue, May 20, 2008 at 7:51 PM, Magnus Damm <magnus.damm@gmail.com> wrote:
> > Add enable_irq() callback to struct uio_info. This callback is needed by
> > the uio_platform driver so interrupts can be enabled before blocking.
> 
> We can most likely use a single uio platform driver if this patch is
> acceptable. Any NAKs?

Yes. Your approach only allows enabling interrupts, but not disabling
them. And I don't like that it is not possible for generic userspace
tools to find out if a UIO device has this auto-irq-enabling capability
or not.

I just posted a patch that allows enabling _and_ disabling of irqs from
userspace by writing 0 or 1 to /dev/uioX. I've CCed you, could you
please test? If this doesn't do what you need, please let me know.

Thanks,
Hans

