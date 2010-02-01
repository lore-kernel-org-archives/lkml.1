Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab0BAQwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:52:46 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:49225 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab0BAQwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:52:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Jd7X0BWDiqbUrCFQDBqu7bqU7DYsl3OlwfbNXjdQmTjqSOdLIgjMC2PQEQVbtk3ZAJ
         wauDVkMrcmrO2ufD4gdNEg6l4B/foWxs0/0+ljy/SXfAz4un4SB5L/UwNdf2Ifkjetxk
         OFDjuBQexx833fJzZJJ8i7VPQVIFmLlG2WwSE=
Date: Mon, 1 Feb 2010 22:23:19 +0530
From: Rabin Vincent <rabin@rab.in>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Abhishek Sagar <sagar.abhishek@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] ftrace: re-enable dynamic ftrace for ARM
Message-ID: <20100201165318.GA1846@debian>
References: <1264959196-5175-1-git-send-email-rabin@rab.in>
 <1264959196-5175-2-git-send-email-rabin@rab.in>
 <20100201102843.GA31714@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100201102843.GA31714@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 11:28:43AM +0100, Uwe Kleine-König wrote:
> On Sun, Jan 31, 2010 at 11:03:16PM +0530, Rabin Vincent wrote:
> > This adds mcount recording and updates dynamic ftrace for ARM to work
> > with the new ftrace dyamic tracing implementation.
[...]
> Wouldn't it be nice to patch out the instruction pushing lr to the
> stack (in the gnu case)?  Should work, shouldn't it.

It would and it should, but the main reasons I didn't do that were:

  - Thumb-2 support needs the LR to be in place, since even -mapcs-frame
    does not seem to give us an APCS frame there.   The LR would also
    be needed if GCC gains the ability to build without frame pointers
    with -pg.

  - I'm not sure we would gain much performance by patching it out, and
    I'd really like to avoid patching more than what is really necessary
    and to keep the code as similar as possible to the other arches.

Rabin
