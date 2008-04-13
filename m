Return-Path: <linux-kernel-owner+w=401wt.eu-S1759170AbYDMNzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759170AbYDMNzz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 09:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757370AbYDMNzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 09:55:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:54549 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757052AbYDMNzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 09:55:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TrWLs44ni9KgWgZ1kT6UzJP7+g0YKzE0ZoFWDYebKoqcnDOM1cdRxNrpj9T1rlsmy7psZq/LGcj5kSmEN6sS48dbPsUKSd4+JZSLsbdxjyV2blQVq7mFYjunzIIblP8SjrT3TUC/nNcOo2rwCBtxXzHUmys6ZViyEn5HJ6jqzD0=
Message-ID: <e2e108260804130655x4d9d694alc3feb3f623264a75@mail.gmail.com>
Date: Sun, 13 Apr 2008 15:55:45 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: [PATCH] Replace completions with semaphores
Cc: "Matthew Wilcox" <matthew@wil.cx>, "Peter Zijlstra" <peterz@infradead.org>,
       "Ingo Oeser" <ioe-lkml@rameria.de>,
       "Daniel Walker" <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>, "Linus Torvalds" <torvalds@osdl.org>
In-Reply-To: <adaskxqrgsl.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080411210022.GJ11962@parisc-linux.org>
	 <1208003081.7427.7.camel@twins>
	 <20080412172606.GL11962@parisc-linux.org> <adaskxqrgsl.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 9:53 PM, Roland Dreier <rdreier@cisco.com> wrote:
>  Just make sure you don't forget the history of completions...  As
>  Linus said long ago (http://lwn.net/2001/0802/a/lt-completions.php3):
>
>   In case anybody cares, the race was that Linux semaphores only protect the
>   accesses _inside_ the semaphore, while the accesses by the semaphores
>   themselves can "race" in the internal implementation. That helps make an
>   efficient implementation, but it means that the race was:
>
>             cpu #1                       cpu #2
>
>             DECLARE_MUTEX_LOCKED(sem);
>             ..
>             down(&sem);                   up(&sem);
>             return;
>                                           wake_up(&sem.wait) /*BOOM*/

Thanks for bringing this back to attention -- I wasn't aware of the
message you cited.

My opinion about the above race is that this race has nothing to do
with the semaphore concept, but that the race is caused by the way in
which the semaphore object is used. Using any object after it has been
destroyed is asking for trouble.

Bart.
