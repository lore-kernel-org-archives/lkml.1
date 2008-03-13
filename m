Return-Path: <linux-kernel-owner+w=401wt.eu-S1757159AbYCMXMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159AbYCMXMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 19:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYCMXM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 19:12:29 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42078 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbYCMXM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 19:12:28 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "Huang, Ying" <ying.huang@intel.com>, nigel@nigel.suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [linux-pm] [PATCH -mm] kexec jump -v9
References: <Pine.LNX.4.44L0.0803121055510.4595-100000@iolanthe.rowland.org>
	<200803122253.07631.rjw@sisk.pl>
	<m1iqzrxy26.fsf@ebiederm.dsl.xmission.com>
	<200803131803.31120.rjw@sisk.pl>
Date: Thu, 13 Mar 2008 17:07:17 -0600
In-Reply-To: <200803131803.31120.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Thu, 13 Mar 2008 18:03:29 +0100")
Message-ID: <m1ejaew7dm.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> From the ACPI compliance point of view it's better to do it this way.  We need
> to put the devices into low power states anyway before "powering off" the
> system and we won't need to touch them for the second time if we do that
> in advance.

Interesting.  From a kexec jump where we exit the kernel and then return
to it seem all that is required.

I will have to look at the ACPI case.  That seems to be the lynch pin
of a couple of arguments for doing strange things: ACPI requires it.

> Still, it would be sufficient if we disconnected the drivers from the hardware
> and thus prevented applications from accessing that hardware.

My gut feeling is that except for a handful of drivers we could even
get away with simply implementing hot unplug and hot replug.  Disks
are the big exception here.

Which suggests to me that it is at least possible that the methods we
want for a kexec jump hibernation may be different from an in-kernel
hibernation and quite possibly are easier to implement.

Eric
