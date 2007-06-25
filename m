Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbXFYVzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbXFYVzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbXFYVzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:55:38 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57426 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751482AbXFYVzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:55:37 -0400
Date: Mon, 25 Jun 2007 23:55:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Uli Luckas <u.luckas@road.de>, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] PM: Prevent frozen user mode helpers from failing the freezing of tasks (rev. 2)
Message-ID: <20070625215527.GE2051@elf.ucw.cz>
References: <200706252352.24137.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706252352.24137.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> [I hope the ACKs still apply.]

Uhuh, not 100% sure.

> +static int usermodehelper_disabled;
> +


...

>  	case PM_HIBERNATION_PREPARE:
>  	case PM_SUSPEND_PREPARE:
>  		usermodehelper_disabled = 1;
> -		return NOTIFY_OK;
> +		smp_mb();

usermodehelper_disabled should be atomic variable, too, so we don't
have to play these ugly tricks by hand? This should not be
performance-critical, right?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
