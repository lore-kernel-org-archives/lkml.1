Return-Path: <linux-kernel-owner+w=401wt.eu-S1762685AbZJOLq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762685AbZJOLq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 07:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758173AbZJOLq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 07:46:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37107 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758125AbZJOLqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 07:46:25 -0400
Date: Thu, 15 Oct 2009 12:47:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Hounschell <dmarkh@cfl.rr.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Hounschell <markh@compro.net>
Subject: Re: WARNING: at lib/kref.c:43 kref_get+0x18/0x20()
Message-ID: <20091015124710.502c45b8@lxorguk.ukuu.org.uk>
In-Reply-To: <4AD6FB9B.5030704@cfl.rr.com>
References: <4AD6FB9B.5030704@cfl.rr.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I know there have been many changes to the serial/tty stuff recently. I think
> this is not a driver but kernel issue so I thought I'd bring it up here in hope
> to find out for sure.

Its probably a combination of the two. While digi persist in keeping
their stuff out of tree its always going to lag and not get fixed in
parallel or even considered during tty reworking.

First guess would be that the driver has paths that free a tty kref but
don't take it (ie unbalanced counts) second that may be it can't cope
with the changes caused by the switches to refcounting throughout the tty
code.

One for Digi to answer given they insist on keeping it out of tree.
