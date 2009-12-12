Return-Path: <linux-kernel-owner+w=401wt.eu-S1762914AbZLLAWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762914AbZLLAWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 19:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762850AbZLLAWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 19:22:54 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:60327 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762703AbZLLAWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 19:22:54 -0500
Date: Sat, 12 Dec 2009 01:21:48 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       samr@ravnborg.org
Subject: Re: hwrng: virtio - Rename driver object to remove section
	mismatch warning
Message-ID: <20091212002148.GA9586@merkur.ravnborg.org>
References: <20091211153658.GA1207@gondor.apana.org.au> <1260559557.24459.1320.camel@calx> <20091211120849.012c43d8.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211120849.012c43d8.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 12:08:49PM -0800, Randy Dunlap wrote:
> On Fri, 11 Dec 2009 13:25:57 -0600 Matt Mackall wrote:
> 
> > On Fri, 2009-12-11 at 23:36 +0800, Herbert Xu wrote:
> > > Hi:
> > > 
> > > Finally found the cause of the section mismatch warning in hwrng.
> > > Apparently in addition to __devexit_p we now have to name the
> > > variable in a certain way.
> > 
> > That's fairly appalling. Any idea why?
> 
> (I haven't read the rest of this thread..)
> 
> scripts/mod/modpost.c looks for certain variable names to identify
> variables that can have references to other (non-data) sections.
> It's mostly explained there.

Another option is to annotate the relevant variable.

>From init.h:
/* modpost check for section mismatches during the kernel build.
 * A section mismatch happens when there are references from a
 * code or data section to an init section (both code or data).
 * The init sections are (for most archs) discarded by the kernel
 * when early init has completed so all such references are potential bugs.
 * For exit sections the same issue exists.
 * The following markers are used for the cases where the reference to
 * the *init / *exit section (code or data) is valid and will teach
 * modpost not to issue a warning.
 * The markers follow same syntax rules as __init / __initdata. */
#define __ref            __section(.ref.text) noinline
#define __refdata        __section(.ref.data)
#define __refconst       __section(.ref.rodata)

	Sam
