Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbXIJNPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbXIJNPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 09:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbXIJNO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 09:14:56 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:2459 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbXIJNOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 09:14:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AGVKK3pVMr1L0auV3fW1onIYqUemNmXNEAHM1t3h2bzPpwus8bBnanTozRYsvnouQ8yh0yHWvZICjC88GBb2gI9vR9i+VG3wbekGhGpqDozQNrNYRVTsIiYjVEF+e9TzvqM8d8c6GOBVP9HCyWjPOWSwzRqRsZO1r446xGxdYPg=
Message-ID: <d120d5000709100614l7a4a651dl4baf64cee1414835@mail.gmail.com>
Date: Mon, 10 Sep 2007 09:14:52 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>,
       "Markus Armbruster" <armbru@redhat.com>
Subject: Re: [PATCH] input: Fix interrupt enable in i8042_ctr when enabling interrupt fails
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, akpm@linux-foundation.org
In-Reply-To: <Pine.LNX.4.58.0709100853340.24030@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <877imy7kw1.fsf@pike.pond.sub.org>
	 <Pine.LNX.4.58.0709100853340.24030@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven, Markus,

On 9/10/07, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> --
> On Mon, 10 Sep 2007, Markus Armbruster wrote:
> >
> > I believe this possible, but unlikely (perhaps not so unlikely on
> > virtual machines).  Scenarios involve enable succeeding the first
> > time, failing the second time, and succeeding the third time.  I can
> > provide details, but the point I'd like to make is not that this is
> > broken (although it is, strictly speaking), but that it is not
> > obviously correct where it easily could be: just clear the interrupt
> > enable bits when writing them to the hardware failed, like the old
> > code did.
> >
>
> I also want to stress that this is more of a clean up for "technically
> correct" code than a bug fix.  This bug probably would never happen on
> baremetal unless it was running on broken hardware.
>
>  BUT!!!
>
> With more and more systems going to a virtual environment, having a bug or
> some other anomaly can trigger the error that this patch prevents. The
> patch will also trigger a print in the case of running on a buggy virtual
> machine, which would help out the developers of that virtual machine to
> fix their code.
>

The patch is in my tree and will be merged in the next window.

-- 
Dmitry
