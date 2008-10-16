Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbYJPLll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbYJPLll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 07:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbYJPLlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 07:41:32 -0400
Received: from ozlabs.org ([203.10.76.45]:38413 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754436AbYJPLlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 07:41:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 4/5] hvc_console: Add tty window resizing
Date: Thu, 16 Oct 2008 22:41:29 +1100
User-Agent: KMail/1.9.9
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux PPC devel <linuxppc-dev@ozlabs.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "Ryan S. Arnold" <rsa@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <20081014091247.433079967@linux.vnet.ibm.com> <20081014091413.306993844@linux.vnet.ibm.com>
In-Reply-To: <20081014091413.306993844@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810162241.29883.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 October 2008 20:12:51 Hendrik Brueckner wrote:
> From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
>
> The patch provides the hvc_resize() function to update the terminal
> window dimensions (struct winsize) for a specified hvc console.
> The function stores the new window size and schedules a function
> that finally updates the tty winsize and signals the change to
> user space (SIGWINCH).
> Because the winsize update must acquire a mutex and might sleep,
> the function is scheduled instead of being called from hvc_poll()
> or khvcd.

I want this functionality for lguest, too.  But I don't see anything which 
uses this call yet?   Are we going to use the config_change notifier from 
virtio?  (Which IIRC neither S/390 nor lguest have plumbed in).

Cheers,
Rusty.


