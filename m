Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbYDBNMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbYDBNMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 09:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbYDBNMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 09:12:40 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2445 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752846AbYDBNMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 09:12:39 -0400
Date: Wed, 2 Apr 2008 15:12:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Oliver Neukum <oliver@neukum.org>,
       Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [RFC][PATCH 1/3] PM: Introduce new top level suspend and hibernation callbacks (rev. 7)
Message-ID: <20080402131215.GC5295@ucw.cz>
References: <200804020207.40278.rjw@sisk.pl> <200804020209.47207.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200804020209.47207.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-04-02 02:09:46, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Introduce 'struct pm_ops' and 'struct pm_ext_ops' ('ext' meaning
> 'extended') representing suspend and hibernation operations for bus
> types, device classes, device types and device drivers.
> 
> Modify the PM core to use 'struct pm_ops' and 'struct pm_ext_ops'
> objects, if defined, instead of the ->suspend() and ->resume(),
> ->suspend_late(), and ->resume_early() callbacks (the old callbacks
> will be considered as legacy and gradually phased out).
> 
> The main purpose of doing this is to separate suspend (aka S2RAM and
> standby) callbacks from hibernation callbacks in such a way that the
> new callbacks won't take arguments and the semantics of each of them
> will be clearly specified.  This has been requested for multiple
> times by many people, including Linus himself, and the reason is that
> within the current scheme if ->resume() is called, for example, it's
> difficult to say why it's been called (ie. is it a resume from RAM or
> from hibernation or a suspend/hibernation failure etc.?).
> 
> The second purpose is to make the suspend/hibernation callbacks more
> flexible so that device drivers can handle more than they can within
> the current scheme.  For example, some drivers may need to prevent
> new children of the device from being registered before their
> ->suspend() callbacks are executed or they may want to carry out some
> operations requiring the availability of some other devices, not
> directly bound via the parent-child relationship, in order to prepare
> for the execution of ->suspend(), etc.
> 
> Ultimately, we'd like to stop using the freezing of tasks for suspend
> and therefore the drivers' suspend/hibernation code will have to take
> care of the handling of the user space during suspend/hibernation.
> That, in turn, would be difficult within the current scheme, without
> the new ->prepare() and ->complete() callbacks.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
