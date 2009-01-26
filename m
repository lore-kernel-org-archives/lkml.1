Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbZAZVQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbZAZVQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 16:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbZAZVQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 16:16:44 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35184 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752003AbZAZVQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 16:16:44 -0500
Date: Mon, 26 Jan 2009 21:16:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, sgrubb@redhat.com, esandeen@redhat.com,
       sukadev@us.ibm.com
Subject: Re: tty: tty_open can return to userspace holding tty_mutex
Message-ID: <20090126211649.0c572376@lxorguk.ukuu.org.uk>
In-Reply-To: <1233003761.9850.14.camel@localhost.localdomain>
References: <1233003761.9850.14.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009 16:02:40 -0500
Eric Paris <eparis@redhat.com> wrote:

> __tty_open could return (to userspace) holding the tty_mutex thanks to a
> regression introduced by 4a2b5fddd53b80efcb3266ee36e23b8de28e761a.  This was
> found by bisecting an fsfuzzer problem.  Admittedly I have no idea how it
> managed to tickle this 100% reliably, but it is clearly a regression and
> when hit leaves the box in a completely unusable state.  This patch lets
> the fsfuzzer test complete every time.

Well spotted, and will go fix now. I think your fsfuzzer created a device
node for an out of range tty subdevice
