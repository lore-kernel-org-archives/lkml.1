Return-Path: <linux-kernel-owner+w=401wt.eu-S1752936AbZBCLAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbZBCLAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 06:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbZBCLAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 06:00:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752000AbZBCLAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 06:00:08 -0500
Date: Tue, 3 Feb 2009 02:59:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Hans de Goede <hdegoede@redhat.com>,
       Matthew Garrett <mjg@redhat.com>, Roland Dreier <rolandd@cisco.com>
Subject: Re: [PATCH] dmi: Let dmi_walk() users pass private data
Message-Id: <20090203025937.2cfca36a.akpm@linux-foundation.org>
In-Reply-To: <20090203105222.34f9f1b5@hyperion.delvare>
References: <20090201224659.6e7e84eb@hyperion.delvare>
	<20090203004210.235f162d.akpm@linux-foundation.org>
	<20090203105222.34f9f1b5@hyperion.delvare>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009 10:52:22 +0100 Jean Delvare <khali@linux-fr.org> wrote:

> On Tue, 3 Feb 2009 00:42:10 -0800, Andrew Morton wrote:
> > On Sun, 1 Feb 2009 22:46:59 +0100 Jean Delvare <khali@linux-fr.org> wrote:
> > 
> > > At the moment, dmi_walk() lacks flexibility, users can't pass data to
> > > the callback function. Add a pointer for private data to make this
> > > function more flexible.
> > 
> > That new argument is sometimes called "priv", other times called "data"
> > and other times called "dummy".  It would be good to come up with a nice
> > meaningful name and stick to it.
> > 
> > (The "dummy" thing probably makes sense, as long as people think to 
> > rename it to the chosen identifier if they later actually use it for
> > something).
> 
> Indeed, naming things "dummy" when they are required for prototype
> reasons but otherwise unused is a rather common strategy.
> 
> As for "priv" vs. "data", I wanted to use "data" everywhere, but it
> happens that we already have a local variable named "data" in function
> dmi_table(). I didn't want to change it, to not make the patch bigger
> and harder to read. If you think this is such a big issue, I could
> either rename that local variable nevertheless, or use "priv"
> everywhere (with the open question whether we should also use "priv"
> instead of "data" in <linux/dmi.h> or not.) Let me know what you prefer.
> 

Could use `private_data' everywhere.   There's a lot of precedent:

y:/usr/src/25> grep private_data Tags | wc -l
228
