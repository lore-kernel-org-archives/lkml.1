Return-Path: <linux-kernel-owner+w=401wt.eu-S1753791AbYJAI3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbYJAI3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 04:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYJAI3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 04:29:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37711 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbYJAI3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 04:29:47 -0400
Date: Wed, 1 Oct 2008 10:29:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Noonan <steven@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH -tip] drivers/serial/8250.c: 'i' may be used
	uninitialized
Message-ID: <20081001082930.GB31009@elte.hu>
References: <20081001080150.GC25832@elte.hu> <1222849017-10896-1-git-send-email-steven@uplinklabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222849017-10896-1-git-send-email-steven@uplinklabs.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Noonan <steven@uplinklabs.net> wrote:

> Signed-off-by: Steven Noonan <steven@uplinklabs.net>
> ---
>  drivers/serial/8250.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

the change is obvious to you, but it's useful to put an analysis into 
the changelog. Something like:

 serial_unlink_irq_chain() does not initialize iterator 'i', and that is 
 correct logically because it is always initialized due to XYZ. Gcc does
 not realize this connection and emits a false warning. Annotate it with 
 uninitialized_var().

and fill in XYZ.

Doing such changelogs is useful to maintainers: they'll see that you 
havent just squashed a warning you noticed, you understood the code and 
determined it via review that the warning is GCC's fault, not the 
kernel's.

with an empty changelog the maintainer will have to do this himself. 
(and can easily put your patch to the tail of a very long TODO list, or 
outright skip your patch.)

	Ingo
