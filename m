Return-Path: <linux-kernel-owner+w=401wt.eu-S1761026AbXGQNBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761026AbXGQNBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 09:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbXGQNBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 09:01:17 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:54798 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbXGQNBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 09:01:17 -0400
Date: Tue, 17 Jul 2007 15:02:30 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Domen Puncer <domen.puncer@telargo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] introduce __init_exit function annotation
Message-ID: <20070717130230.GB24780@uranus.ravnborg.org>
References: <20070717080248.GK4375@moe.telargo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717080248.GK4375@moe.telargo.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 10:02:48AM +0200, Domen Puncer wrote:
> Introduce __init_exit, which is useful ie. for drivers that call
> cleanup functions when they fail in __init functions.

This is wrong.
On arm (just one example of several) the __exit section are discarded
at buildtime so any reference from __init to __exit will cause the
linker to error out.

The real solution is only to declare functiones used solely during
exit as __exit.
The whole point of using __exit is to tell that this can be safely
dropped when built-in because it is not used then.

	Sam
