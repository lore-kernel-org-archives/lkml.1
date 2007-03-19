Return-Path: <linux-kernel-owner+w=401wt.eu-S964789AbXCSUiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964789AbXCSUiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964796AbXCSUiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:38:05 -0400
Received: from smtp.osdl.org ([65.172.181.24]:54990 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964789AbXCSUiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:38:02 -0400
Date: Mon, 19 Mar 2007 13:36:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "J.H." <warthog9@kernel.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysctl: vfs_cache_divisor
Message-Id: <20070319133613.9f4881db.akpm@linux-foundation.org>
In-Reply-To: <20070319122740.286f602e.randy.dunlap@oracle.com>
References: <20061214223718.GA3816@elf.ucw.cz>
	<20061216094421.416a271e.randy.dunlap@oracle.com>
	<20061216095702.3e6f1d1f.akpm@osdl.org>
	<458434B0.4090506@oracle.com>
	<1166297434.26330.34.camel@localhost.localdomain>
	<20061219063413.GI24090@1wt.eu>
	<1166511171.26330.120.camel@localhost.localdomain>
	<20070106103331.48150aed.randy.dunlap@oracle.com>
	<459FF60D.7080901@zytor.com>
	<1168112266.2821.2.camel@entropy>
	<20070106121301.d07de0c9.akpm@osdl.org>
	<45A0041F.4060903@zytor.com>
	<20070319122740.286f602e.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 12:27:40 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> +The default vfs_cache_divisor value is 100 (like percent).  However, for
> +extremely large systems where a value of vfs_cache_pressure of less than
> +1 percent is desirable, using a larger vfs_cache_divisor enables this wanted
> +characteristic.

The one-percent-granularity problem also applies to /proc/sys/vm/*dirty*
and possibly other things.  So any fix we do should be applicable to those
as well.

And I'm not really sure how we should do this.  I do think that we should
change the kernel so these knobs are internally higher-resolution.  So, for
example, we switch all the logic so that instead of these variables
representing 1/100th, they instead represent 1/1000000th, for example.

Then, we change the top-level /proc handler to do the 1/100th <-> 1/1000000th
conversion.  So the rest of the kernel doesn't have to know about it.

The we duplicate all the relevant /proc knobs:

cat /proc/sys/vm/dirty_ratio
30
cat /proc/sys/vm/hires-dirty_ratio/
300000

Or we do something else ;)
