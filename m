Return-Path: <linux-kernel-owner+w=401wt.eu-S1758781AbZFISE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781AbZFISE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 14:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbZFISEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 14:04:21 -0400
Received: from mx1.emlix.com ([193.175.82.87]:34016 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbZFISEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 14:04:20 -0400
Date: Tue, 9 Jun 2009 20:04:16 +0200
From: Oskar Schirmer <os@emlix.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oskar Schirmer <os@emlix.com>, Sascha Hauer <kernel@pengutronix.de>,
       linux-kernel@vger.kernel.org, Fabian Godehardt <fg@emlix.com>
Subject: Re: [PATCH 8/8] imx: serial: add IrDA support to serial driver
Message-ID: <20090609180416.GA1213@emlix.com>
References: <1244555211-15618-3-git-send-email-os@emlix.com> <1244555211-15618-4-git-send-email-os@emlix.com> <1244555211-15618-5-git-send-email-os@emlix.com> <1244555211-15618-6-git-send-email-os@emlix.com> <1244555211-15618-7-git-send-email-os@emlix.com> <1244555211-15618-8-git-send-email-os@emlix.com> <1244555211-15618-9-git-send-email-os@emlix.com> <20090609160132.31265ffc@lxorguk.ukuu.org.uk> <20090609161817.GA17246@emlix.com> <20090609180738.10014627@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090609180738.10014627@lxorguk.ukuu.org.uk>
Organization: emlix GmbH
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 18:07:38 +0100, Alan Cox wrote:
> > Sure, the path will be optimized away, but still
> > the conditional statement is subjected to syntax
> > and scope analysis and gcc will correctly complain
> > that irda_inv_rx is not declared.
> 
> Why are only about half of them done this way rather than all ?

Because only half of them use IrDA specific struct fields
directly, thus need to be ifdef'd explicitely.

Like I wrote before, we could replace all the

if (USE_IRDA(x)) ...

with some

#ifdef CONFIG_IRDA
if (x->use_irda) ...

but that way we would have more ifdef's around.
A matter of taste, I'ld say. If you vote for the
latter, we can adjust the patch accordingly, of
course.

  Oskar
