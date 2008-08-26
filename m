Return-Path: <linux-kernel-owner+w=401wt.eu-S1757729AbYHZJ7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729AbYHZJ7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 05:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbYHZJ7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 05:59:03 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38754 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbYHZJ7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 05:59:01 -0400
Date: Tue, 26 Aug 2008 11:50:32 +0200
From: Pavel Machek <pavel@suse.cz>
To: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: default to reboot via ACPI
Message-ID: <20080826095032.GA309@elf.ucw.cz>
References: <1219659087-17536-1-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219659087-17536-1-git-send-email-avi@qumranet.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-08-25 13:11:27, Avi Kivity wrote:
> Triple-fault and keyboard reset may assert INIT instead of RESET; however
> INIT is blocked when Intel VT is enabled.  This leads to a partially reset
> machine when invoking emergency_restart via sysrq-b: the processor is still
> working but other parts of the system are dead.
> 
> Default to rebooting via ACPI, which correctly asserts RESET and reboots the
> machine.
> 
> This is safe since we will fall back to keyboard reset and triple fault if
> acpi is not enabled or if the reset is not successful.
> 
> Signed-off-by: Avi Kivity <avi@qumranet.com>

"ACPI" and "safe" in one sentence. /me bets this will break lot of
machines.

What about only doing that when enabling VT?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
