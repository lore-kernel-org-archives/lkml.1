Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbZHYBlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbZHYBlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 21:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbZHYBlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 21:41:25 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43455 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbZHYBlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 21:41:24 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: v2.6.31-rc6: BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
References: <m163cjhwa4.fsf@fess.ebiederm.org>
	<m1skfnggrb.fsf@fess.ebiederm.org>
	<alpine.LFD.2.01.0908241530070.3824@localhost.localdomain>
	<alpine.LFD.2.01.0908241632060.3824@localhost.localdomain>
	<alpine.LFD.2.01.0908241655370.3824@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 24 Aug 2009 18:41:15 -0700
In-Reply-To: <alpine.LFD.2.01.0908241655370.3824@localhost.localdomain> (Linus Torvalds's message of "Mon\, 24 Aug 2009 17\:09\:08 -0700 \(PDT\)")
Message-ID: <m1k50soekk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: torvalds@linux-foundation.org, gregkh@suse.de, alan@lxorguk.ukuu.org.uk, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, 24 Aug 2009, Linus Torvalds wrote:
>> 
>> But I wanted to let people know that the patch is clearly not the "last 
>> word" on this. It's a useful thing to try, but we need something better.
>
> This may be better (this is a replacement for the previous patch).
>
> Instead of using 'cancel_delayed_work_sync()', it makes tty_ldisc_hangup() 
> do a 'flush_scheduled_work()' afterwards, like the other callers already 
> do.
>
> And like 'tty_ldisc_release()' already does, it does this all before even 
> getting the ldisc_mutex, avoiding the deadlock.
>
> I'm not 100% happy with this patch either, but my remaining unhappiness is 
> more with the tty locking in general that causes this all. I suspect this 
> patch in itself is not any worse than the other hacks we have.
>
> Oh, and in case you didn't guess - this is _STILL_ totally untested. It 
> compiles for me, but that's all I'm going to guarantee. I'm just looking 
> at the code (and getting pretty fed up with it ;)
>
> And as already mentioned: I doubt the deadlock on tty->ldisc_mutex is 
> anything that would be hit in practice. And even if it can be triggered, 
> the previous patch I sent out is still interesting in a "does it make the 
> problem go away" sense. Because if it doesn't (with or without a new 
> deadlock), then I'm looking at all the wrong places.

Assuming no one beats me to it I should be able to test this tomorrow.

Eric
