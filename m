Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbYAAKrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbYAAKrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 05:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbYAAKrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 05:47:09 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:56049 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbYAAKrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 05:47:08 -0500
Date: Tue, 1 Jan 2008 11:47:06 +0100
From: Andreas Mohr <andi@lisas.de>
To: Mikko Vinni <mmvinni@yahoo.com>
Cc: htejun@gmail.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       shaohua.li@intel.com, len.brown@intel.com, bzolnier@gmail.com,
       linux-pm@lists.linux-foundation.org
Subject: Re: IDE/ACPI related hibernation regression: Second attempt fails
Message-ID: <20080101104706.GA10009@rhlx01.hs-esslingen.de>
References: <90645.12978.qm@web58415.mail.re3.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90645.12978.qm@web58415.mail.re3.yahoo.com>
X-Priority: none
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[added Tejun and Rafael CCs]

Hi,

On Mon, Dec 31, 2007 at 01:27:50PM -0800, Mikko Vinni wrote:
> Hi,
> 
> I noticed my ancient laptop (HP nx9005) fails to hibernate (suspend to disk) more than once while running recent 2.6.24-rc kernels. First hibernation succeeds happily, but when I try to do it again after resuming, the machine hangs immediately after the familiar two pops from the speakers."Hanging" in this case means that none of the usual keys work (e.g. Caps Lock led doesn't toggle), but alt-sysrq-b does reboot the laptop.

I'm sorry, but "recent 2.6.24-rc kernels" unfortunately is a statement almost
as broad as "there's a violent fire in India, please come and rescue us!",
given that this very issue has been handled with lots of activity by Tejun Heo
recently (see bug #9530 and http://lkml.org/lkml/2007/12/9/184 for details).

2.6.24-rc6 is the version that has all ACPI IDE fixes in a state that made
my system fully work, so there should be a sizeable chance that it works
for you, too, hopefully.

What's interesting is that you're ALi-based, whereas I'm VIA-based, so
your problem might still be unsupported by -rc6 after all.

> Dmesg of the failing kernel after first hibernation (version is untouched e697789d64f8748cb219d7f5c413c512953802cc, i.e. current 2.6.24-rc6):
           ^^^^^^^^^

Argh, just saw this at the very last moment, IOW if this is _really_
-rc6+ already then we certainly do have a problem.

Disassembled ACPI BIOS AML code (DSDT) of your machine would be very useful
in this case, I'm afraid (done via acpidump and iasl, search the internet for
pointers).
lspci -x or better -xxx of the IDE device would be very useful, too.

Thanks for your verbose report,

Andreas Mohr
