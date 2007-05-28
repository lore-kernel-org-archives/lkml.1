Return-Path: <linux-kernel-owner+w=401wt.eu-S1760275AbXE1NMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275AbXE1NMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 09:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbXE1NMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 09:12:49 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33757 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751662AbXE1NMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 09:12:48 -0400
Date: Mon, 28 May 2007 15:12:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC][PATCH -mm 1/3] PM: Hibernation and suspend notifiers
Message-ID: <20070528131243.GP18807@elf.ucw.cz>
References: <200705272229.21263.rjw@sisk.pl> <200705272230.04478.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705272230.04478.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Make it possible to register hibernation and suspend notifiers, so that
> subsystems can perform hibernation-related or suspend-related operations that
> should not be carried out by device drivers' .suspend() and
> .resume() routines.

I believe it adds _way_ too many notifiers.

> +PM_PRE_FREEZE		The system is going to hibernate or suspend, tasks will
> +			be frozen immediately

80 columns. Anyway yes, this one is needed.

> +PM_POST_THAW		Tasks have just been thawed after a resume or restore
> +			from a hibernation image

Symetrical with the previous one, useful for freeing firmware images, ok.

> +PM_HIBERNATION_PREPARE	The system is preparing for hibernation.  Tasks have
> +			been frozen, memory is going to be freed and devices
> +			are going to be suspended.

What is this one good for?

> +PM_SNAPSHOT_FAILED	The creation of hibernation image has failed.  Tasks
> +			will be thawed immediately.

Does this one need to be different from POST_THAW?

I do not see the need for the other chains. Notice that we do not
_want_ to have too many of them, because changing anything in the
hibernation will become impossible with 10 chains having intimate
details of suspend sequence.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
