Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbZBCJwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbZBCJwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 04:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbZBCJwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 04:52:40 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:1487 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbZBCJwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 04:52:40 -0500
Date: Tue, 3 Feb 2009 10:52:22 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Hans de Goede <hdegoede@redhat.com>,
       Matthew Garrett <mjg@redhat.com>, Roland Dreier <rolandd@cisco.com>
Subject: Re: [PATCH] dmi: Let dmi_walk() users pass private data
Message-ID: <20090203105222.34f9f1b5@hyperion.delvare>
In-Reply-To: <20090203004210.235f162d.akpm@linux-foundation.org>
References: <20090201224659.6e7e84eb@hyperion.delvare>
	<20090203004210.235f162d.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009 00:42:10 -0800, Andrew Morton wrote:
> On Sun, 1 Feb 2009 22:46:59 +0100 Jean Delvare <khali@linux-fr.org> wrote:
> 
> > At the moment, dmi_walk() lacks flexibility, users can't pass data to
> > the callback function. Add a pointer for private data to make this
> > function more flexible.
> 
> That new argument is sometimes called "priv", other times called "data"
> and other times called "dummy".  It would be good to come up with a nice
> meaningful name and stick to it.
> 
> (The "dummy" thing probably makes sense, as long as people think to 
> rename it to the chosen identifier if they later actually use it for
> something).

Indeed, naming things "dummy" when they are required for prototype
reasons but otherwise unused is a rather common strategy.

As for "priv" vs. "data", I wanted to use "data" everywhere, but it
happens that we already have a local variable named "data" in function
dmi_table(). I didn't want to change it, to not make the patch bigger
and harder to read. If you think this is such a big issue, I could
either rename that local variable nevertheless, or use "priv"
everywhere (with the open question whether we should also use "priv"
instead of "data" in <linux/dmi.h> or not.) Let me know what you prefer.

Thanks,
-- 
Jean Delvare
