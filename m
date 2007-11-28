Return-Path: <linux-kernel-owner+w=401wt.eu-S1758738AbXK1IKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbXK1IKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 03:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbXK1IKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 03:10:24 -0500
Received: from mx1.riseup.net ([204.13.164.18]:34634 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbXK1IKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 03:10:24 -0500
Date: Wed, 28 Nov 2007 09:10:31 +0100
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question regarding mutex locking
Message-ID: <20071128081031.GF20238@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	LKML <linux-kernel@vger.kernel.org>
References: <474CF06C.8020208@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474CF06C.8020208@lwfinger.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, Nov 27, 2007 at 10:37:00PM -0600 Larry Finger ha dit:

> If a particular routine needs to lock a mutex, but it may be entered with that mutex already locked,
> would the following code be SMP safe?
> 
> hold_lock = mutex_trylock()
> 
> ...
> 
> if (hold_lock)
> 	mutex_unlock()

this is wont work, a mutex must not be released from another
context than the one that acquired it.

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

                Don't walk behind me, I may not lead
             Don't walk in front of me, I may not follow
                Just walk beside me and be my friend
                          (Albert Camus)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
