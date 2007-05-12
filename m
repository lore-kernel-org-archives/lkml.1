Return-Path: <linux-kernel-owner+w=401wt.eu-S1760274AbXELVOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760274AbXELVOg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 17:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754696AbXELVOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 17:14:30 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:52849 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbXELVO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 17:14:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O+vxKbODATkCZMcLNclHIzqbu5w1acwE9PdYVmFrm0L+MUhlZz0J2egOAelxFpDC5kNM9NdlhPcm9PlzF8/yEdA79NxfAVuOdUiL21ZaSPcx7b7reQb6YnnJrD4caIhHF5fW2s5foN90CEs6qhySFBZ+bLHplqDFPk6Tl9fXhgo=
Message-ID: <a781481a0705121414i5aa396dfjf17cf4ade9d399a3@mail.gmail.com>
Date: Sun, 13 May 2007 02:44:28 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Simon Arlott" <simon@fire.lp0.eu>
Subject: Re: default y idiocy
Cc: "Jens Axboe" <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <46461C77.5040404@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070512182343.GO4629@kernel.dk>
	 <46461C77.5040404@simon.arlott.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/13/07, Simon Arlott <simon@fire.lp0.eu> wrote:
> On 12/05/07 19:23, Jens Axboe wrote:
> > Hi,
> >
> > This has bothered me for a long time, and it just seems to be getting
> > worse. Can people please STOP defaulting non-essential stuff to 'y'?
> > Grrr.
>
> Is there a reason why various 10/100/1000Mbit network cards are 'y' too?
> There's even a default SCSI 'm' that seems to be completely hidden from
> the menu too (CONFIG_SCSI_WAIT_SCAN). It depends on SCSI but I can't
> disable SCSI...

Yeah, I've seen a lot of unnecessary default y's too, seems to be a
contagious disease.

And there are another kind of (harmless) default y's too, that don't really
force unnecessary compilation and linking of stuff into the kernel at all,
ones like (21-mm2's) init/Kconfig: SLUB_DEBUG = default y (it's
completely contained in mm/slub.c and not exposed to mm/Makefile),
but it still seems funny to find a spurious CONFIG_SLUB_DEBUG=y in
your .config when you also have # CONFIG_SLUB is not set.

Do we care enough to fix such cases too? This was a one-liner, so
including a patch anyway, CC'ing to Andrew and Christoph.

---

Prevent SLUB_DEBUG from being set if SLUB is not. SLUB_DEBUG
without SLUB does not cause anything to be compiled or linked in
anyway, so this is not critical, but simply removes a spurious
CONFIG_SLUB_DEBUG=y from creeping into the .config even when
CONFIG_SLUB is not set.

Signed-off-by: Satyam Sharma <satyam.sharma@gmail.com>

---

diff -ruNp a-mm2/init/Kconfig b-mm2/init/Kconfig
--- a-mm2/init/Kconfig	2007-05-10 23:19:36.000000000 +0530
+++ b-mm2/init/Kconfig	2007-05-13 02:33:21.000000000 +0530
@@ -567,7 +567,7 @@ config VM_EVENT_COUNTERS
 	  if VM event counters are disabled.

 config SLUB_DEBUG
-	default y
+	default y if SLUB
 	bool "Enable SLUB debugging support" if EMBEDDED
 	help
 	  SLUB has extensive debug support features. Disabling these can
