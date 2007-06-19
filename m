Return-Path: <linux-kernel-owner+w=401wt.eu-S1762133AbXFSSl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762133AbXFSSl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 14:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761959AbXFSSls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 14:41:48 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:35274 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636AbXFSSlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 14:41:47 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18040.9056.755569.67029@stoffel.org>
Date: Tue, 19 Jun 2007 14:41:36 -0400
From: "John Stoffel" <john@stoffel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Change in default vm_dirty_ratio
In-Reply-To: <20070618164711.9de1c38e.akpm@linux-foundation.org>
References: <1182201271.4883.22.camel@localhost.localdomain>
	<20070618164711.9de1c38e.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Andrew" == Andrew Morton <akpm@linux-foundation.org> writes:

Andrew> On Mon, 18 Jun 2007 14:14:30 -0700
Andrew> Tim Chen <tim.c.chen@linux.intel.com> wrote:

>> IOZone write drops by about 60% when test file size is 50 percent of
>> memory.  Rand-write drops by 90%. 

Andrew> heh.

Andrew> (Or is that an inappropriate reaction?)

>> Is there a good reason for turning down the default dirty ratio?

Andrew> It seems too large.  Memory sizes are going up faster than
Andrew> disk throughput and it seems wrong to keep vast amounts of
Andrew> dirty data floating about in memory like this.  It can cause
Andrew> long stalls while the system writes back huge amounts of data
Andrew> and is generally ill-behaved.

Shouldn't the vm_dirty_ratio be based on the speed of the device, and
not the size of memory?  So slower devices can't keep as much in
memory as fast devices?  That would seem to be a better metric.  And
of course those with hundreds of disks will then complain we're taking
too much memory as well, even though they can handle it.  

So per-device vm_dirty_ratio, capped with a vm_dirty_total_ratio seems
to be what we want, right?

John
