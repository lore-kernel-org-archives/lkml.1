Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbXKYGkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbXKYGkj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 01:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbXKYGjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 01:39:47 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36314 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753427AbXKYGjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 01:39:45 -0500
Date: Sat, 24 Nov 2007 22:38:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: rct@gherkin.frus.com (Bob Tracy)
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Message-Id: <20071124223835.ddd5f6e4.akpm@linux-foundation.org>
In-Reply-To: <20071118052036.11B45DBA2@gherkin.frus.com>
References: <20071118052036.11B45DBA2@gherkin.frus.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Nov 2007 23:20:36 -0600 (CST) rct@gherkin.frus.com (Bob Tracy) wrote:

> Completely reproducible... 2.6.23-rc3 kernel boots, and normal messages
> are seen on console as far as disks found and partitions on each.  However,
> once /dev is populated and the boottime scripts attempt to check filesystem
> status, no partitions on either of the two disks attached to the SCSI
> controller are seen.  Dropping into a single-user root shell confirms
> the sudden "blindness": fdisk can't open /dev/sda.
> 
> When I reboot on 2.6.24-rc2, everything works normally.
> 
> System environment is Debian Etch.  Both 2.6.24-rc2 and -rc3 were built
> from the respective unaltered kernel.org source trees, using the same
> kernel configuration modulo saying "no" to CONFIG_SENSORS_I5K_AMB and
> CONFIG_PID_NS in -rc3.  No problems with -rc3 on a x86 box.

Could be something change in sysfs.  Please double-check the config
options, make sure that something important didn't get disabled.

Failing that, it would be great if you could bisect this down to the
offending commit.  http://www.kernel.org/doc/local/git-quick.html has help.

Richard, Ivan: have you seen anything like this?

Meanwhile, I guess we should track this as another post-2.6.23 regression
please.

Thanks.
