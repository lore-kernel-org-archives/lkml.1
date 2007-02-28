Return-Path: <linux-kernel-owner+w=401wt.eu-S932194AbXB1SS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194AbXB1SS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 13:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932210AbXB1SS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 13:18:26 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:43888 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194AbXB1SSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 13:18:25 -0500
Date: Wed, 28 Feb 2007 23:47:03 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Machek <pavel@ucw.cz>, Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problem with freezable workqueues
Message-ID: <20070228181703.GC7021@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <200702272251.28844.rjw@sisk.pl> <20070227232855.GA457@tv-sign.ru> <200702280057.36198.rjw@sisk.pl> <20070228030726.GK29179@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228030726.GK29179@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 28, 2007 at 08:37:26AM +0530, Srivatsa Vaddagiri wrote:
> 
> Hmm ..good point. So can we assume that disable/enable_nonboot_cpus() are called
> with processes frozen already?
> 
> Gautham, you need to take this into account in your patchset!

Yup. That would mean making the freezer reentrant since we will
be freezing twice (once for suspend and later on for hotplug). This is
ok since the api in my patches looks like
freeze_processes(int freeze_event);

But thaw will be interesting. If we are thawing for hotplug, we gotta
only thaw processes which were frozen *only* for hotplug.

Rafael, does that mean more status flags?!

Thanks and Regards
gautham.

-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
