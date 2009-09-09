Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbZIIIHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbZIIIHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 04:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbZIIIHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 04:07:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517AbZIIIHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 04:07:11 -0400
Date: Wed, 9 Sep 2009 01:06:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: tomaz.mertelj@guest.arnes.si, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] hwmon: Driver for Texas Instruments 
 amc6821 chip
Message-Id: <20090909010625.4c8780e9.akpm@linux-foundation.org>
In-Reply-To: <20090909093435.60531d95@hyperion.delvare>
References: <20090905_120834_010267.tomaz.mertelj@guest.arnes.si>
	<20090908170649.855dd1ff.akpm@linux-foundation.org>
	<20090909093435.60531d95@hyperion.delvare>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Sep 2009 09:34:35 +0200 Jean Delvare <khali@linux-fr.org> wrote:

> > Also, the checkpatch warning
> > 
> > WARNING: consider using strict_strtol in preference to simple_strtol
> > #381: FILE: drivers/hwmon/amc6821.c:228:
> > +       int val = simple_strtol(buf, NULL, 10); \
> > 
> > is valid.  The problem with simple_strtol() is that it will treat input
> > of the form "43foo" as "43".  Even though the input was invalid.  A
> > minor thing, but easily fixed too.
> 
> Is there any legitimate use of simple_strtol then?

Probably not, unless it's known that the input is a legit decimal
string.

> I'm wondering why we
> don't just get rid of it and rename strict_strtol to just strtol.

Well.  The calling convention is pretty different, the callers need to
be changed to handle errors.  But the main problem is that changing
existing interfaces to use strict_strtol() could break existing
userspace.


