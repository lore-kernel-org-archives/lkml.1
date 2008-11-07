Return-Path: <linux-kernel-owner+w=401wt.eu-S1754376AbYKGT2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbYKGT2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 14:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbYKGT2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 14:28:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750940AbYKGT17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 14:27:59 -0500
Date: Fri, 7 Nov 2008 11:27:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: djwong@us.ibm.com, khali@linux-fr.org, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH 1/5] adt7462: New hwmon driver
Message-Id: <20081107112731.cec03a04.akpm@linux-foundation.org>
In-Reply-To: <1226084691.11596.42.camel@brick>
References: <20081107185621.13022.61885.stgit@elm3a70.beaverton.ibm.com>
	<20081107185626.13022.59407.stgit@elm3a70.beaverton.ibm.com>
	<1226084691.11596.42.camel@brick>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2008 11:04:51 -0800
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> On Fri, 2008-11-07 at 10:56 -0800, Darrick J. Wong wrote:
> > New driver to play with.  As Jean mentioned a couple of years ago,
> > this
> > chip is a beast with odd combinations of 8 fans, 4 temperatures, and 
> > 13 voltage sensors.  This driver has been tested on an IntelliStation
> > Z30.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> > ---
> > +#define MASK_AND_SHIFT(value, prefix)	\
> > +	(((value) & prefix##_MASK) >> prefix##_SHIFT)
> > +
> 
> I'm not sure, but doesn't this exist somewhere in the common kernel
> headers.

No, core kernel doesn't have a macro which requires that the caller
previously defined foo_MASK and foo_SHIFT.  Only drivers are allowed to
get away with such fugliness ;)

> > +#define ROUND_DIV(x, divisor)  (((x) + ((divisor) / 2)) / (divisor))
> 
> DIV_ROUND_UP ?

That's different.  This one should be called ROUND_CLOSEST or something
like that.

