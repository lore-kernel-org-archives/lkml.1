Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab0BOLTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 06:19:21 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:41467 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab0BOLTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 06:19:19 -0500
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Christian Casteyde" <casteyde.christian@free.fr>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Tejun Heo" <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [Bug #14999] possible circular locking dependency detected in rfkill at suspend
References: <Z5cmiqDComP.A.gyF.OiIeLB@chimera>
	<4un6Gst5rKB.A.Im.WkIeLB@chimera>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 15 Feb 2010 03:19:11 -0800
In-Reply-To: <4un6Gst5rKB.A.Im.WkIeLB@chimera> (Rafael J. Wysocki's message of "Mon\, 15 Feb 2010 00\:38\:29 +0100 \(CET\)")
Message-ID: <m1wryed9w0.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14999
> Subject		: possible circular locking dependency detected in rfkill at suspend
> Submitter	: Christian Casteyde <casteyde.christian@free.fr>
> Date		: 2010-01-06 21:52 (40 days old)

I have a set of patches to clear up the sysfs lockdep false positives.  
http://lkml.org/lkml/2010/2/11/329

It requires sprinking a bunch of sysfs_attr_init on the few dynamically
allocated sysfs attributes, and I haven't found them all yet.  Otherwise
it seems to be working well.

Greg should pick up those patches shortly and they should be appearing
in linux-next and then ultimately in 2.6.34.

Eric
