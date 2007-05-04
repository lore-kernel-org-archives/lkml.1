Return-Path: <linux-kernel-owner+w=401wt.eu-S933094AbXEDPVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094AbXEDPVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933100AbXEDPVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:21:37 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43775 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933094AbXEDPVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:21:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "[PATCH] paravirt: Add startup infrastructure for paravirtualization"
References: <m1mz0ku7je.fsf@ebiederm.dsl.xmission.com>
	<1178280770.23670.61.camel@localhost.localdomain>
	<m1y7k4smmo.fsf@ebiederm.dsl.xmission.com> <463B4A69.6020203@goop.org>
Date: Fri, 04 May 2007 09:20:24 -0600
In-Reply-To: <463B4A69.6020203@goop.org> (Jeremy Fitzhardinge's message of
	"Fri, 04 May 2007 07:59:53 -0700")
Message-ID: <m17irosjif.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Eric W. Biederman wrote:
>> It's not theatrical.  It makes this code path extremely brittle and
>> very hard to change, which over the long term means that it is
>> impossible to maintain.  Quickly resulting in a state where any little
>> change will break something.
>
> Removing the code now is premature.  I'm presuming you're proposing this
> as a .23 change, since we're planning on changing the paravirt boot to
> make use of bzImage and the boot protocol then anyway.

.22 and possibly -stable.  -stable doesn't really matter because it is dead
code.

> The world isn't going to fall apart if its in there for a couple of months.

As long as the code remains dead and unused I don't really care when we purge it.

             That code should NEVER EVER be used.

               That code is UNMAINTAINABLE.

The code encourages random ABIs so we don't even know what we are supporting.
Once used in a production environment (i.e. where we have to support it)
it makes further changes to head.S essentially impossible.

Despite the lack of Documentation we not counting the paravirt mess in
head.S we have a well defined ABI for starting a linux-kernel.  Given the
generally difficulty of changing bootloaders I have no interesting is
messing up a good thing.

Eric
