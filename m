Return-Path: <linux-kernel-owner+w=401wt.eu-S1762882AbXE1RWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762882AbXE1RWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 13:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbXE1RW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 13:22:26 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:57925 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbXE1RWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 13:22:25 -0400
Date: Mon, 28 May 2007 19:22:24 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: "Tilman Schmidt" <tilman@imap.cc>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Greg KH" <greg@kroah.com>
Subject: Re: 2.6.22-rc2-mm1
Message-ID: <20070528192224.0cf237d0@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <3ae72650705271541o2c3755edwdc769883e79820e5@mail.gmail.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	<46585953.80200@imap.cc>
	<20070526090117.dda72286.akpm@linux-foundation.org>
	<465A033C.3070400@imap.cc>
	<3ae72650705271541o2c3755edwdc769883e79820e5@mail.gmail.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2007 00:41:19 +0200,
"Kay Sievers" <kay.sievers@vrfy.org> wrote:

> Cornelia,
> in the patch is:
>   +	if (dev->kobj.parent == &dev->class->subsys.kobj)
>   +		return 0;
> 
> which will skip the creation of the "device"-link, right?

Uh, looking at the code again, this doesn't seem to be what I wanted :(

> But still, I don't think the transaction-style of error handling is
> what we want, it's for some critical subsystems the equivalent of
> adding PANIC(), and this just for a failing symlink-creation. I think
> we just want to print the to the logs, and not let the whole core
> device registration fail entirely.

Hm, but failure to create a symlink usually signifies something's really
wrong (no memory, or an object is there which shouldn't)?
