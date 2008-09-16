Return-Path: <linux-kernel-owner+w=401wt.eu-S1752617AbYIPELS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbYIPELS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 00:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbYIPELE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 00:11:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47016 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbYIPELD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 00:11:03 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/18] lirc serial port receiver/transmitter device driver
Date: Tue, 16 Sep 2008 00:08:43 -0400
User-Agent: KMail/1.10.1 (Linux/2.6.25.16-1.fc10.x86_64; KDE/4.1.1; x86_64; ; )
Cc: Janne Grunau <j@jannau.net>, Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>,
       Christoph Bartelmus <lirc@bartelmus.de>
References: <200809112149.25762.stefan.bauer@cs.tu-chemnitz.de> <200809142355.38387.jwilson@redhat.com> <200809151420.32130.jwilson@redhat.com>
In-Reply-To: <200809151420.32130.jwilson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809160008.43218.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 September 2008 14:20:31 Jarod Wilson wrote:
> On Sunday 14 September 2008 23:55:38 Jarod Wilson wrote:
> > On Saturday 13 September 2008 04:41:33 Stefan Bauer wrote:
> > > On Saturday 13 September 2008 02:26, Janne Grunau wrote:
> > > > I hope I haven't broken anything with my lirc_dev changes. I doubt
> > > > I'll have a change to test it before monday.
> > >
> > > Unfortunately, you did. Commit ea74897 (port lirc to dynamic device
> > > numbers) broke things.
[...]
> So I've done a bit of work to fix up a few drivers so they properly check
> to see that lirc_register_driver() actually succeeded, and then
> accidentally stumbled onto the fix for the failure when merging some
> coverity-inspired patches from Erik Hovland. lirc_dev.c's lirc_cdev_add()
> function had an inverted kmalloc failure check. With that fixed, lirc_i2c
> appears to be behaving for me now, although I can't actually check to be
> 100% certain until I get home tonight.
[...]
> Fixes are in the git tree now for anyone else who wants to or is willing to
> test. Will verify myself tonight w/lirc_i2c and lirc_mceusb2 at a minimum.

Current git tree works for receiving IR signals via lirc_serial (tested by 
Janne) and via lirc_mceusb2 (tested by me). Something is still slightly 
haywire with lirc_i2c though. It registers fine, but IR signals simply aren't 
making it to lircd. Probably unrelated to the dynamic device num changes, 
looking into it.

-- 
Jarod Wilson
jarod@redhat.com

