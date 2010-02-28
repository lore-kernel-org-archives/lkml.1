Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030465Ab0B1QfT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 11:35:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:60049 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030247Ab0B1QfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 11:35:18 -0500
Subject: Re: [PATCH] Driver core: Reduce the level of request_firmware()
 messages
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <201002281313.38483.rjw@sisk.pl>
References: <201002272143.22156.rjw@sisk.pl>
	 <3f9a31f41002272043t59d18d39ga0296ce3f6602c6d@mail.gmail.com>
	 <201002281313.38483.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 28 Feb 2010 22:03:05 +0530
Message-Id: <1267374785.1929.2.camel@i7.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rafael,

On Sun, 2010-02-28 at 13:13 +0100, Rafael J. Wysocki wrote:
> On Sunday 28 February 2010, Jaswinder Singh Rajput wrote:
> > On Sun, Feb 28, 2010 at 2:13 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > >
> > > The messages from _request_firmware() informing that firmware is
> > > being requested or built-in firmware is going to be used are printed
> > > at KERN_INFO, which produces lots of noise on systems with huge
> > > numbers of AMD CPUs.  Reduce the level of these messages to
> > > KERN_DEBUG to get rid of that noise.
> > >
> > 
> > Which firmware we are using is very useful information. Because of
> > huge numbers of CPUs it seems noise then better provide the
> > information for first cpu and for the rest of the CPUs you can show by
> > KERN_DEBUG.
> 
> That would have been better indeed, but the problem is _request_firmware()
> doesn't allow us to change the level of its messages on demand.

Can we try this :

	if (smp_processor_id())
		dev_dbg(..);
	else
		dev_info(..);

Thanks,
--
Jaswinder Singh.

