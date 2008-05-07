Return-Path: <linux-kernel-owner+w=401wt.eu-S1762404AbYEGGR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762404AbYEGGR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 02:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbYEGGRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 02:17:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756099AbYEGGQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 02:16:58 -0400
Date: Tue, 6 May 2008 23:11:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: djwong@us.ibm.com, mhoffman@lightlink.com, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [resend] [PATCH v2] ibmaem: New driver for  power/energy meters
 in IBM System X hardware
Message-Id: <20080506231114.d5a0b6e7.akpm@linux-foundation.org>
In-Reply-To: <20080507080105.5484c58a@hyperion.delvare>
References: <20080503045558.GJ16078@tree.beaverton.ibm.com>
	<20080505135621.66809b0e.akpm@linux-foundation.org>
	<20080505230440.GE16404@tree.beaverton.ibm.com>
	<20080506140433.0fa6e68e.akpm@linux-foundation.org>
	<20080506223812.GF16404@tree.beaverton.ibm.com>
	<20080506173607.71eb7257.akpm@linux-foundation.org>
	<20080507080105.5484c58a@hyperion.delvare>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 7 May 2008 08:01:05 +0200 Jean Delvare <khali@linux-fr.org> wrote:

> On Tue, 6 May 2008 17:36:07 -0700, Andrew Morton wrote:
> > A checkpatch version which you might not have says
> > 
> > WARNING: consider using strict_strtol in preference to simple_strtol
> > #1015: FILE: drivers/hwmon/ibmaem.c:918:
> > +       int temp = simple_strtol(buf, NULL, 10); \
> > 
> > total: 0 errors, 1 warnings, 1221 lines checked
> > 
> > because the code as you have it will accept input of the form "12foo". 
> > strict_strtol() will error on that.
> 
> As a side note, I really wonder why this new function wasn't named just
> strtol(), especially if the general idea is to get rid of the "simple"
> variant after some time.

didn't think of doing that.

But:

y:/home/akpm> cat t.c
#include <stdlib.h>
#include <stdio.h>

main()
{
        unsigned long u = strtoul("12foo", 0, 10);
        printf("%lu\n", u);
}
y:/home/akpm> gcc t.c
y:/home/akpm> ./a.out
12


strtoul() has different behaviour.
