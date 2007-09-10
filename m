Return-Path: <linux-kernel-owner+w=401wt.eu-S1759625AbXIJNAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625AbXIJNAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 09:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758062AbXIJM7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 08:59:54 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:63450 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481AbXIJM7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 08:59:53 -0400
Date: Mon, 10 Sep 2007 08:59:11 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Markus Armbruster <armbru@redhat.com>
cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org,
       Dmitry Torokhov <dtor@mail.ru>, akpm@linux-foundation.org
Subject: Re: [PATCH] input: Fix interrupt enable in i8042_ctr when enabling
 interrupt fails
In-Reply-To: <877imy7kw1.fsf@pike.pond.sub.org>
Message-ID: <Pine.LNX.4.58.0709100853340.24030@gandalf.stny.rr.com>
References: <877imy7kw1.fsf@pike.pond.sub.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Mon, 10 Sep 2007, Markus Armbruster wrote:
>
> I believe this possible, but unlikely (perhaps not so unlikely on
> virtual machines).  Scenarios involve enable succeeding the first
> time, failing the second time, and succeeding the third time.  I can
> provide details, but the point I'd like to make is not that this is
> broken (although it is, strictly speaking), but that it is not
> obviously correct where it easily could be: just clear the interrupt
> enable bits when writing them to the hardware failed, like the old
> code did.
>

I also want to stress that this is more of a clean up for "technically
correct" code than a bug fix.  This bug probably would never happen on
baremetal unless it was running on broken hardware.

  BUT!!!

With more and more systems going to a virtual environment, having a bug or
some other anomaly can trigger the error that this patch prevents. The
patch will also trigger a print in the case of running on a buggy virtual
machine, which would help out the developers of that virtual machine to
fix their code.

Please apply.

-- Steve

