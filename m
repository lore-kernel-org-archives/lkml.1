Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbXKJPoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbXKJPoI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 10:44:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754514AbXKJPm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 10:42:56 -0500
Received: from mx1.suse.de ([195.135.220.2]:32903 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509AbXKJPmz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 10:42:55 -0500
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [RFC 9/13] Char: nozomi, lock cleanup
Date: Sat, 10 Nov 2007 16:42:51 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <25311158751454229887.slaby@pripojeni.net>
In-Reply-To: <25311158751454229887.slaby@pripojeni.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200711101642.52289.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Samstag 10 November 2007 00:48:52, you (Jiri Slaby) wrote:
> nozomi, lock cleanup
> 
> - semaphore is deprecated, use mutex instead
> - don't return -ERESTARTSYS when signal might not be pending since it's not
>   permitted (unknown retval mioght reach userspace)
> - don't lock interruptible in close or the card might not be stopped on last
>   close

Good catches. But i had to change it a bit, especially the mutex_trylock.
>From mutex.c: "..it is negated to the down_trylock() return values!
Be careful about this when converting semaphores to mutexes." ;-)
Now it works again (doesn't deadlock my card anymore).

Thanks,
Frank
