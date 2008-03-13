Return-Path: <linux-kernel-owner+w=401wt.eu-S1756384AbYCMKNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbYCMKNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 06:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbYCMKLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 06:11:43 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35273 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269AbYCMKLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 06:11:42 -0400
Date: Thu, 13 Mar 2008 09:37:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 1/3] PM: Handle device registrations during
	suspend/resume
Message-ID: <20080313083713.GA20299@elf.ucw.cz>
References: <200803120055.25885.rjw@sisk.pl> <200803120057.23101.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803120057.23101.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-03-12 00:57:22, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Modify the PM core to protect its data structures, specifically the
> dpm_active list, from being corrupted if a child of the currently
> suspending device is registered concurrently with its ->suspend()
> callback.  In that case, since the new device (the child) is added
> to dpm_active after its parent, the PM core will attempt to
> suspend it after the parent, which is wrong.
> 
> Introduce a new member of struct dev_pm_info, called 'sleeping',
> and use it to check if the parent of the device being added to
> dpm_active has been suspended, in which case the device registration
> fails.  Also, use 'sleeping' for checking if the ordering of devices
> on dpm_active is correct.
> 
> Introduce variable 'all_sleeping' that will be set to 'true' once all
> devices have been suspended and make new device registrations fail
> until 'all_sleeping' is reset to 'false', in order to avoid having
> unsuspended devices around while the system is going into a sleep state.
> 
> Remove pm_sleep_rwsem which is not necessary any more.
> 
> Special thanks to Alan Stern for discussions and suggestions that
> lead to the creation of this patch.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
