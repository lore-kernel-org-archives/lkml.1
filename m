Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbYGXLvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbYGXLvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 07:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755546AbYGXLvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 07:51:39 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:36133 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbYGXLvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 07:51:38 -0400
Date: Thu, 24 Jul 2008 05:51:22 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andi Kleen <andi@firstfloor.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Oops in sched_mc_power_savings_store
Message-ID: <20080724115121.GA28269@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have no idea how you guys intended this to work, but here's the
debugging work I've done so far.

[   89.210171] Call Trace:
[   89.210182]  [<c011c0b3>] ? sched_mc_power_savings_store+0x0/0x4a
[   89.210198]  [<c02908c0>] ? sysdev_class_store+0x38/0x40
[   89.210213]  [<c01a0b51>] ? sysfs_write_file+0xb9/0xe4

sched_mc_power_savings_store isn't a class attribute, it's a plain
attribute.  So the prototypes are different.  This is why we try to load
from address 2 -- it's actually the length parameter.

I don't know how our typing system let this one through.  I don't know if
you want to fix this by adding an extra argument to the class_attribute
show and store methods.  I don't know if sched_mc_power_savings_store
was intended to be a class attribute or not.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
