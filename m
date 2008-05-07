Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbYEGAhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbYEGAhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 20:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbYEGAhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 20:37:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752806AbYEGAhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 20:37:04 -0400
Date: Tue, 6 May 2008 17:36:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: djwong@us.ibm.com
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       mhoffman@lightlink.com
Subject: Re: [resend] [PATCH v2] ibmaem: New driver for power/energy meters
 in IBM System X hardware
Message-Id: <20080506173607.71eb7257.akpm@linux-foundation.org>
In-Reply-To: <20080506223812.GF16404@tree.beaverton.ibm.com>
References: <20080503045558.GJ16078@tree.beaverton.ibm.com>
	<20080505135621.66809b0e.akpm@linux-foundation.org>
	<20080505230440.GE16404@tree.beaverton.ibm.com>
	<20080506140433.0fa6e68e.akpm@linux-foundation.org>
	<20080506223812.GF16404@tree.beaverton.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 15:38:13 -0700 "Darrick J. Wong" <djwong@us.ibm.com> wrote:

> [resend due to truncation]
> Refactor the registration function to shrink the macros.  Let me know if
> more aggressive de-macroing is desirable.
> ---
> New driver for power meters in IBM System X hardware, with a few
> cleanups suggested by Anthony Liguori.
> 
> ...
>
> +	int temp = simple_strtol(buf, NULL, 10); \

A checkpatch version which you might not have says

WARNING: consider using strict_strtol in preference to simple_strtol
#1015: FILE: drivers/hwmon/ibmaem.c:918:
+       int temp = simple_strtol(buf, NULL, 10); \

total: 0 errors, 1 warnings, 1221 lines checked

because the code as you have it will accept input of the form "12foo". 
strict_strtol() will error on that.

afacit the calling code would perhaps need a little changing to handle
such errors appropriately.
