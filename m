Return-Path: <linux-kernel-owner+w=401wt.eu-S1759404AbZEaQcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404AbZEaQcP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 12:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbZEaQcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 12:32:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34636 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751248AbZEaQcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 12:32:00 -0400
Date: Sun, 31 May 2009 17:31:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Olivier Galibert <galibert@pobox.com>
Cc: paul@mad-scientist.net, linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] coredump: Retry writes where appropriate
Message-ID: <20090531173144.0a552386@lxorguk.ukuu.org.uk>
In-Reply-To: <20090531140354.GA92675@dspnet.fr.eu.org>
References: <1243748019.7369.319.camel@homebase.localnet>
	<20090531111851.07eb1df3@lxorguk.ukuu.org.uk>
	<20090531140354.GA92675@dspnet.fr.eu.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> Perhaps removing the "|| r == -EINTR" part would make both of you
> happy?  He gets the reliability on pipes, you keep the interrupt on
> signals.

How does that improve things.

There is a second problem anyway. Suppose something is causing a
continual stream of signal events - what guarantees it makes progress ?

The only source of signals during a dump should be external ones. Far
better would be to set some kind of defined signal mask during the dump
(say SIGPIPE, SIGINT, SIGQUIT) ? I agree with Paul's patch in the sense
we don't want spurious SIGIO events or similar spoiling a dump.

Alan
