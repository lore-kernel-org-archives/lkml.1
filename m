Return-Path: <linux-kernel-owner+w=401wt.eu-S934152AbZKXViW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934152AbZKXViW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933729AbZKXViV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:38:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32997 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933620AbZKXViV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:38:21 -0500
Subject: Re: [PATCH 02/38] move atp870u_remove to .devexit.text
From: James Bottomley <James.Bottomley@suse.de>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Yang Hongyang <yanghy@cn.fujitsu.com>, Alan Cox <alan@linux.intel.com>,
       linux-scsi@vger.kernel.org, Alan Cox <alan@redhat.com>
In-Reply-To: <1259096853-18909-2-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1259096853-18909-2-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 15:38:16 -0600
Message-Id: <1259098696.4549.643.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 22:06 +0100, Uwe Kleine-König wrote:
> The function atp870u_remove is used only wrapped by __devexit_p so define
> it using __devexit.

But there's really no point to this.  HOTPLUG is always defined on SCSI
systems that have these drivers, which means that _devinit/exit are
nops.  That makes the change purely cosmetic and not worth churning two
dozen drivers for.

Even for the EMBEDDED cases that should care about this, the maintainers
have indicated that the memory savings simply aren't worth the hassle of
tracking the sectional updates.

James


