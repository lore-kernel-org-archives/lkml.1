Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649Ab0ACLOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab0ACLOY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 06:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624Ab0ACLOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 06:14:23 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:46565 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab0ACLOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 06:14:22 -0500
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: drm_vm.c:drm_mmap: possible circular locking dependency detected
References: <20091228092712.AA8C.A69D9226@jp.fujitsu.com>
	<alpine.LFD.2.00.0912301259220.11961@localhost.localdomain>
	<m11victac1.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.0912301348320.11961@localhost.localdomain>
	<m1fx6rtu31.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.0912311043330.11961@localhost.localdomain>
	<m11vi9c0td.fsf@fess.ebiederm.org> <4B3EB687.7000005@kernel.org>
	<m17hs0xjmn.fsf@fess.ebiederm.org> <4B3FE586.7020109@kernel.org>
	<20100103074745.GA2314@core.coreip.homeip.net>
	<m1tyv3sbg4.fsf@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 03 Jan 2010 03:14:18 -0800
In-Reply-To: <m1tyv3sbg4.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Sun\, 03 Jan 2010 02\:57\:15 -0800")
Message-ID: <m1d41rsanp.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> What to do about it is another question.   It has just recently come to my
> attention that we have more events like this

In the specific case of serio what gets us in trouble is
the call to sysfs_remove_group.

If instead of independent calls to sysfs_create_group/sysfs_remove_group,
you could move the groups into a list on dev->groups than we could solve
two problems.

- Userspace would see all of the attributes when the hotplug event is
  fired remove races.

- We would not hold serio->drv_mutex over sysfs_remove_group so there
  would not be a possible deadlock on device removal.

Does that change sound possible?

Eric


