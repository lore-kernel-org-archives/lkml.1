Return-Path: <linux-kernel-owner+w=401wt.eu-S1757599AbYGLCcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599AbYGLCcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 22:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbYGLCcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 22:32:06 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58194 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbYGLCcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 22:32:05 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, Huang Ying <ying.huang@intel.com>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1215401122.4660.4.camel@caritas-dev.intel.com>
	<20080711122131.b6461ab1.akpm@linux-foundation.org>
	<20080711202434.GB6261@elf.ucw.cz> <200807112240.59461.rjw@sisk.pl>
Date: Fri, 11 Jul 2008 19:23:04 -0700
In-Reply-To: <200807112240.59461.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Fri, 11 Jul 2008 22:40:58 +0200")
Message-ID: <m1lk076dtj.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Rafael J. Wysocki" <rjw@sisk.pl>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4330]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH -mm 1/2] kexec jump -v12: kexec jump
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> The truth is we could do hibernation without the freezer if
> (a) some drivers were fixed not to rely on it (kexec doesn't help here),
> (b) we had support at the block layer or filesystems level (kexec is a big
>    workaround here).

I just realized with a little care the block layer does have support for this,
or something very close.

You setup a software raid mirror with one disk device.    The physical
device can come in and out while the filesystems depend on the real device.

I expect a hardware pass through device configured to do exactly the
above would be about 100 lines of code, so getting past the filesystem
hurdle should be very doable.  Arguably we should be able to do this
up a level, but it is easy enough to do that you can do a proof of
concept with out that.

Now I'm curious to see how far you can go with just the device hotplug support.

Eric
