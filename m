Return-Path: <linux-kernel-owner+w=401wt.eu-S965526AbXCTRHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965526AbXCTRHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 13:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965529AbXCTRHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 13:07:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965526AbXCTRHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 13:07:18 -0400
Date: Tue, 20 Mar 2007 13:01:02 -0400
From: Bill Nottingham <notting@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: new sysfs layout and ethernet device names
Message-ID: <20070320170102.GA16341@nostromo.devel.redhat.com>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was fiddling with the 'new' (no CONFIG_SYSFS_DEPRECATED) layout
and ethernet device names, and noticed that the new layout effectively
restricts the availability of certain device names.

By making a directory for the ethernet device name in the parent
device, you no longer can use any name that is used in sysfs for
the parent device type - for PCI devices this would be 'resource0',
'power', 'enable', etc. For USB, it would be a different set
of names that are no longer available.

If you *do* try to use one of these names, the rename will succeed...
partway. The link in /sys/class/net is renamed, the directory is
not (as it obviously can't rename on top of whatever is already there.)
Various networking tools then break in assorted ways due to the
naming disconnect.

Going back to the deprecated layout makes these names available again -
it's possible (although not necessarily likely) that the new layout
will break someone's device configuration if they upgrade kernels,
even if the rest of their tools are updated for the new layout.

Bill


