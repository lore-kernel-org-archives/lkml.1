Return-Path: <linux-kernel-owner+w=401wt.eu-S1761662AbYBTCkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761662AbYBTCkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 21:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755729AbYBTCkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 21:40:08 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47517 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891AbYBTCkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 21:40:06 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, roland@redhat.com,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] do_signal_stop: use signal_group_exit()
References: <20080215180204.GA4359@tv-sign.ru>
	<20080215193756.9e5b8205.akpm@linux-foundation.org>
	<20080216140212.GA1421@tv-sign.ru> <20080217231019.GA83@tv-sign.ru>
Date: Tue, 19 Feb 2008 19:32:34 -0700
In-Reply-To: <20080217231019.GA83@tv-sign.ru> (Oleg Nesterov's message of
	"Mon, 18 Feb 2008 02:10:19 +0300")
Message-ID: <m1fxvo73y5.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

>
>>From 2.6.25-rc2-mm1.bz2 patch:
>>
>> -       .ioctl          = tty_ioctl,
>> +       .unlocked_ioctl = tty_ioctl,
>
> and this is why this didn't happen before, I guess.

Right.  Does anyone know what kind of audit was made of the tty code
to ensure everything would be fine?

It it was pretty thorough and it was just this little corner case
it makes sense to get the struct tty locking for pids correct.

Otherwise since the tty layer is historically not especially good
with it's locking. We should just revert the change above, and save
attacking this until someone has time to do a thorough review.

Eric
