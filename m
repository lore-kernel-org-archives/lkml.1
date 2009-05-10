Return-Path: <linux-kernel-owner+w=401wt.eu-S1751352AbZEJEdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbZEJEdU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 00:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750751AbZEJEdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 00:33:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:51132 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbZEJEdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 00:33:09 -0400
Date: Sat, 9 May 2009 21:34:04 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Greg KH <gregkh@suse.de>
Cc: Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] devtmpfs patches
Message-ID: <20090509213404.6cd040f7@infradead.org>
In-Reply-To: <20090509161923.GA942@suse.de>
References: <20090509143742.GA27663@kroah.com>
	<b637ec0b0905090810t188e39e3w92d9f4eff04011f1@mail.gmail.com>
	<20090509150853.GA32394@suse.de>
	<20090509082233.32cbb8e4@infradead.org>
	<20090509161923.GA942@suse.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 May 2009 09:19:23 -0700
Greg KH <gregkh@suse.de> wrote:


btw... I would be a LOT happier about the solution from a technical
point of view if it wasn't the kernel making the device node, but the
kernel exposing a file with a list of all devices, so that userland can
chose to mknod or not, with which permissions if non-default and with
non-default owners.
So basically (and I'm making up a filename here, don't read too much
into that)

cat /proc/alldevices

c   1     4         foobar
b   8     0         sda
c   122   12        dri/card0

etc
making the actual nodes from this in the most simple case is basically
no time in userspace, but a slightly more advanced early userspace app
can even do permissions for the few device nodes where it matters etc.

I can imagine that being a good solution that ends up solving your
problem, but in a way that is more consistent with what the kernel does
right now and how we can then have userland make decisions on where to
make the nodes, with what perms etc etc.
In fact such a file would be a greeat help in general, and would be a
nice generic solution.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
