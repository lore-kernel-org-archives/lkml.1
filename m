Return-Path: <linux-kernel-owner+w=401wt.eu-S1752593AbYIJAEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbYIJAEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 20:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYIJAEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 20:04:42 -0400
Received: from scing.com ([217.160.110.58]:44556 "EHLO scing.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbYIJAEm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 20:04:42 -0400
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
From: Janne Grunau <j@jannau.net>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 03/18] lirc driver for 1st-gen Media Center Ed. USB IR transceivers
Date: Wed, 10 Sep 2008 02:04:38 +0200
User-Agent: KMail/1.9.9
Cc: Jarod Wilson <jwilson@redhat.com>, linux-kernel@vger.kernel.org,
       Christoph Bartelmus <lirc@bartelmus.de>, Janne Grunau <j@jannau.net>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <1220933164-10160-4-git-send-email-jwilson@redhat.com> <20080909132140.3c0adcca@bike.lwn.net>
In-Reply-To: <20080909132140.3c0adcca@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200809100204.38616.j@jannau.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 21:21:40 Jonathan Corbet wrote:
> > +error:
> > +     mceusb_delete(dev);
> > +     dev = NULL;
> > +     dprintk("%s: retval = %x", __func__, retval);
> > +     up(&minor_table_mutex);
> > +     return retval;
> > +}
>
> This will leak the memory allocated for dev.  It also leaves the
> entry in minor_table pointing to a nonfunctional device.

Argh, I replied too quickly.

kfree(dev) and minor_table cleanup are in mceusb_delete()

Janne
