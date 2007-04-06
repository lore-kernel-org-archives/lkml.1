Return-Path: <linux-kernel-owner+w=401wt.eu-S933287AbXDFQoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287AbXDFQoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 12:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933286AbXDFQoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 12:44:25 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60713 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933285AbXDFQoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 12:44:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>, greg@kroah.coM
Subject: [PATCH 0/5] On to usable sysfs shadow directory support...
Date: Fri, 06 Apr 2007 10:43:43 -0600
Message-ID: <m164898ncw.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The following patchset has been tested on 2.6.21-rc6 + Kay's
driver-core-fix-namespace-issue-with-devices-assigned-to-classes.patch

It has been tested both with CONFIG_SYSFS_DEPRECATED set and
unset.  Although more testing has been involved with CONFIG_SYSFS_DEPRECATED
unset because that was the hard case.

After the change of network devices from struct class_device to struct device
it has taken me a while to figure out how to get the shadow directory support
to actually work in a maintainable race free manner.  I wound up pushing
a lot more of the logic down into sysfs to accomplish this (primarily shadow
directory creation and deletion).  Which radically change the interfaces to
how I work with shadow directories at the upper levels.

So this patchset:

- fixes some aesthetic issues with Kay's patch.
- Rips out almost all of the old shadow directory support.
- Adds new shadow directory support.
- Adds some shadow directory friendly symlink manipulators
- Adds struct class and struct support for shadow directories.

Eric
