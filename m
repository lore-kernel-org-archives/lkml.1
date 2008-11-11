Return-Path: <linux-kernel-owner+w=401wt.eu-S1752709AbYKKXVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbYKKXVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 18:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbYKKXVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 18:21:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751568AbYKKXVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 18:21:11 -0500
Date: Tue, 11 Nov 2008 15:20:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Trent Piepho <tpiepho@freescale.com>
Cc: djwong@us.ibm.com, khali@linux-fr.org, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 1/2] Create a DIV_ROUND_CLOSEST macro to do
 division with rounding
Message-Id: <20081111152007.ff508e26.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0811111459300.24267@t2.domain.actdsltmp>
References: <20081111010132.1730.76566.stgit@elm3a70.beaverton.ibm.com>
	<Pine.LNX.4.64.0811111459300.24267@t2.domain.actdsltmp>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008 15:05:02 -0800 (PST)
Trent Piepho <tpiepho@freescale.com> wrote:

> On Mon, 10 Nov 2008, Darrick J. Wong wrote:
> > diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> > index fba141d..fb02266 100644
> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> > @@ -48,6 +48,12 @@ extern const char linux_proc_banner[];
> > #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
> > #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
> > #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
> > +#define DIV_ROUND_CLOSEST(x, divisor)(			\
> > +{							\
> > +	typeof(divisor) __divisor = divisor;		\
> > +	(((x) + ((__divisor) / 2)) / (__divisor));	\
> > +}							\
> > +)
> 
> Maybe you can do away with the statement-expression extension?  I've seen
> cases where it cases gcc to generate worse code.  It seems like it
> shouldn't, but it does.  I know DIV_ROUND_CLOSEST (maybe DIV_ROUND_NEAR?)
> uses divisor twice, but all the also divide macros do that too, so why does
> this one need to be different?

The others need fixing too.

> Note that if divisor is a signed variable, divisor/2 generates worse code
> than divisor>>1.

yup.  I wonder why the compiler doesn't do that for itself - is there a
case where it will generate a different result?

