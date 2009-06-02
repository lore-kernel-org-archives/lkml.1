Return-Path: <linux-kernel-owner+w=401wt.eu-S1756601AbZFBJF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbZFBJF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 05:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbZFBJFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 05:05:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33023 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751826AbZFBJFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 05:05:14 -0400
Date: Tue, 2 Jun 2009 10:00:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Cliff Cai <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH 04/11] Blackfin SPORT UART: fix overrun errors
Message-ID: <20090602100018.415b1dfc@lxorguk.ukuu.org.uk>
In-Reply-To: <1243926700-30485-4-git-send-email-vapier@gentoo.org>
References: <1243926700-30485-1-git-send-email-vapier@gentoo.org>
	<1243926700-30485-4-git-send-email-vapier@gentoo.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  2 Jun 2009 03:11:33 -0400
Mike Frysinger <vapier@gentoo.org> wrote:

> From: Cliff Cai <cliff.cai@analog.com>
> 
> Push the ty_flip_buffer_push() call from the IRQ handler to a timer so as
> to improve performance and decrease likelihood of overruns.

This should have no effect on a modern kernel. There is 64K of queueing
between you and the ldisc nowdays. Furthermore unless you set
tty->low_latency the kernel already basically does this aggregation for
you as the buffer push queues stuff for the ldisc to wake up and process.

