Return-Path: <linux-kernel-owner+w=401wt.eu-S1763049AbZJOVaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763049AbZJOVaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 17:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754958AbZJOVap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 17:30:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43581 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754902AbZJOVap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 17:30:45 -0400
Date: Thu, 15 Oct 2009 22:31:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Stuge <peter@stuge.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Hardware initialization in line discipline - ldisc_open() ?
Message-ID: <20091015223137.6b9fb55a@lxorguk.ukuu.org.uk>
In-Reply-To: <20091015205803.30544.qmail@stuge.se>
References: <20091015205803.30544.qmail@stuge.se>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Since the packet format is the same it would be easy to reuse the
> normal ldisc receive path for the handshake, however the ldisc would
> not see the response until after ldisc_open() has succeeded.

Indeed.

> Can you suggest a solution to this problem? Ideally one that can be
> contained in the ldisc.

Similar problem with the GSM mux I've been working on. I've gone for
making the ldisc attach always work and then kicking things off via an
ioctl which sets the desired mode/parameters/encoding.
