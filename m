Return-Path: <linux-kernel-owner+w=401wt.eu-S1755884AbXKKIRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbXKKIRT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 03:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbXKKIRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 03:17:09 -0500
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3784 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbXKKIRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 03:17:07 -0500
Message-ID: <12888.80.126.27.205.1194769013.squirrel@webmail.xs4all.nl>
Date: Sun, 11 Nov 2007 09:16:53 +0100 (CET)
Subject: Re: AppArmor Security Goal
From: "Rob Meijer" <capibara@xs4all.nl>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: "Crispin Cowan" <crispin@crispincowan.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "LSM ML" <linux-security-module@vger.kernel.org>,
       "apparmor-dev" <apparmor-dev@forge.novell.com>
Reply-To: rmeijer@xs4all.nl
User-Agent: SquirrelMail/1.4.11
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, November 10, 2007 22:04, Andi Kleen wrote:
> Crispin Cowan <crispin@crispincowan.com> writes:
>
> The document should be a good base for a merge.
>
>>     * A confined process can operate on a file descriptor passed to it
>>       by an unconfined process, even if it manipulates a file not in the
>>       confined process's profile. To block this attack, confine the
>>       process that passed the file descriptor.
>
> That is the only thing that tripped me up a bit while reading the
> document.
> Can you expand a bit on the reasons why the fd is not rechecked in
> the context of the target process? Best do it in a new version of the
> document.

You must try to considder what could actualy be a valid reason for
re-checking here, and what it could accomplish.
If the unconfined process A is in 'full communication' with the unconfined
process B and wants B to have the 'authority' to do anything with file C
that it can do, there is no way of stopping A from doing so.
Stopping A from communicating its 'permission' to do so would thus be
useless for that purpose. The only way of stopping A from comminucating
its authority with A is stopping A from communicating with B period.

Ones you accept that trying to stop delegation of authority by stopping
delegation of permission is useless, you can see that ther are major
advantages with respect to allowing a process with least authority, if
you actualy 'accomodate' the delegation of authority.

This is the main reason why I actualy feel strongly that a more extended
set of delegation possibilities (both of ambient and object capabilities)
would be complementary to AppArmor, in that it would allow the convenience
of defining the lower bound of priviledges to a delegation based scheme,
while allowing at the same time a 'thin profile' for OC aware programs.

Rob J Meijer

