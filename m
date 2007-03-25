Return-Path: <linux-kernel-owner+w=401wt.eu-S1752343AbXCYMG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbXCYMG3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 08:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbXCYMG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 08:06:29 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59598 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbXCYMG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 08:06:28 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Thomas Meyer <thomas@m3y3r.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <gregkh@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	<20070323185022.GQ752@stusta.de> <46055A3B.6050107@m3y3r.de>
	<m1slbu4j0p.fsf@ebiederm.dsl.xmission.com> <46056BF3.3070707@m3y3r.de>
	<m1odmi4gx5.fsf@ebiederm.dsl.xmission.com> <46058B47.60204@m3y3r.de>
	<m1fy7u3sas.fsf@ebiederm.dsl.xmission.com> <46065FED.8030206@m3y3r.de>
Date: Sun, 25 Mar 2007 06:03:57 -0600
In-Reply-To: <46065FED.8030206@m3y3r.de> (Thomas Meyer's message of "Sun, 25
	Mar 2007 13:41:33 +0200")
Message-ID: <m11wjd4jiq.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer <thomas@m3y3r.de> writes:

> Eric W. Biederman schrieb:
>>
>> Thomas could you verify the patch below makes the problem go away
>> for you.
>>   
>
> The patch solves the problem. I'm writing this after the third suspend
> and resume cycle.
> msi irq stays enabled for libata device:
> cat /sys/devices/pci0000\:00/0000\:00\:1f.2/irq
> 218

> The first suspend to disk is ok. The second suspend to disk has a
> strange behaviour:
> 1.) write pm image
> 2.) the system disable the non-boot cpus again (i guess this happens in
> power_down())
> 3.) the system doesn't power down.
> 4.) pressing any key and the system powers down.
>
> The same is true for the third suspend cycle. Maybe an acpi problem?

Sounds possible.  You could probably verify it isn't my patch but running
an unpatched kernel without msi support.  As I think the crash you saw should
only be reproducible when using devices that support msi.

Unless I hear different I'm going to assume that this second case is a
completely different problem.  You might check to see if the acpi
interrupt is stuck after a suspend/resume cycle.

At this point I'm going to wait a bit for Tony and Len to have a
chance to give their opinion but unless I hear something I'm going to
plan on sending the patch out shortly...

Eric
