Return-Path: <linux-kernel-owner+w=401wt.eu-S1758801AbXHTDdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801AbXHTDdJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 23:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbXHTDc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 23:32:57 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:59682 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbXHTDc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 23:32:56 -0400
Date: Mon, 20 Aug 2007 12:31:43 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH 1/1] ensure we don't use bootconsoles after init has been released
Message-ID: <20070820033143.GA4918@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mike Frysinger <vapier.adi@gmail.com>,
	Robin Getz <rgetz@blackfin.uclinux.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	Gerd Hoffmann <kraxel@redhat.com>
References: <200708192246.05783.rgetz@blackfin.uclinux.org> <8bd0f97a0708192011m1b957e57je313850a255dcac7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0708192011m1b957e57je313850a255dcac7@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2007 at 11:11:47PM -0400, Mike Frysinger wrote:
> On 8/19/07, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> > +static int __init disable_boot_consoles(void)
> > +{
> > +       struct console *con;
> > +
> > +       for (con = console_drivers; con; con = con->next) {
> > +               if (con->flags & CON_BOOT) {
> > +                       printk(KERN_INFO "Turn off boot console %s%d\n",
> > +                               con->name, con->index);
> > +                       unregister_console(con);
> > +               }
> > +       }
> > +}
> 
> erp, no 'return 0;' ... that'll earn you a warning at build time and
> maybe random failures depending on the arch ...

Or better yet, complain if unregister_console() fails, and pass the
failure down.
