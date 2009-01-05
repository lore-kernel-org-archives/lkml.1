Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbZAEK6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbZAEK6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 05:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbZAEK6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 05:58:33 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39314 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbZAEK6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 05:58:32 -0500
Date: Mon, 5 Jan 2009 11:58:30 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [RFC][PATCH 5/10] PCI PM: Avoid touching devices behind bridges in unknown state (rev. 2)
Message-ID: <20090105105830.GH27199@atrey.karlin.mff.cuni.cz>
References: <200812190049.34343.rjw@sisk.pl> <200812302333.45560.rjw@sisk.pl> <200812302341.12959.rjw@sisk.pl> <200901012209.47598.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901012209.47598.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Subject: PCI PM: Avoid touching devices behind bridges in unknown state (rev. 2)
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> It generally is better to avoid accessing devices behind bridges that
> may not be in the D0 power state, because in that case the bridges'
> secondary buses may not be accessible.  For this reason, during the
> early phase of resume (ie. with interrupts disabled), before
> restoring the standard config registers of a device, check the power
> state of the bridge the device is behind and postpone the restoration
> of the device's config space, as well as any other operations that
> would involve accessing the device, if that state is not D0.

I'm not sure if this is good idea.

Either pci config space needs to be restored early, or it can wait.

Sometimes restoring it early and sometimes restoring it late seems
harmful: it will make code harder to understand and harder to test.

> In such cases the restoration of the device's config space will be
> retried during the "normal" phase of resume (ie. with interrupts
> enabled), so that the bridge can be put into D0 before that happens.

If drivers have to assume it is restored late, anyway... why not do it
late, always?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
