Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbYDTV0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbYDTV0h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 17:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYDTV03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 17:26:29 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:63936 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbYDTV03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 17:26:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gnJ6waKVFTunY0dRjQhXX7t41/jbqvx7Kzq8os3o8tHEXJHfunFVa3c7O/sajODwDHxessp1q41C6LjQpPQHXH4jWWZ6DO99SV5nUbBOA78qc28ljA+fQ1I3TG8QhHnULmznAqGJZBHbA9LzrIy59xI8wRgNAkQQnDbbGA4dSBA=
Message-ID: <b647ffbd0804201426r3bb55daw2899f6045b78fa51@mail.gmail.com>
Date: Sun, 20 Apr 2008 23:26:28 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Dan Upton" <upton.dan.linux@gmail.com>
Subject: Re: migration thread and active_load_balance
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <ba7d8f720804201121h6c024dcrabd301c8b4be7a4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ba7d8f720804201121h6c024dcrabd301c8b4be7a4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/04/2008, Dan Upton <upton.dan.linux@gmail.com> wrote:
> Back again with more questions about the scheduler, as I've spent two
>  or three days trying to debug on my own and I'm just not getting
>  anywhere.
>
>  Basically, I'm trying to add a new active balancing mechanism.  I made
>  out a diagram of how migration_thread  calls active_load_balance and
>  so on, and I use a flag (set by writing to a file in sysfs) to
>  determine whether to use the standard iterator for the CFS runqueue or
>  a different iterator I wrote.  The new iterator seems to work fine, as
>  I've been using it (again, with a flag) to replace the regular
>  iterator when it's called from schedule by idle_balance.  I basically
>  tried adding an extra conditional in migration_thread that sets up
>  some state and then calls active_load_balance, but I was getting
>  deadlocks.  I'm not really sure why, since all I've really changed is
>  add a few variables to struct rq and struct cfs_rq.
>
>  I tried only doing my state setup and restore in that conditional,
>  without actually calling active_load_balance, which has given me an
>  even more frustrating result--the kernel does not deadlock, but it
>  does seem to crash in such a manner as to require a hard reset of the
>  machine.  (For instance, at one point I got an "invalid page state in
>  process 'init'" message from the kernel; if I try to reboot from Gnome
>  though it hangs.)  I don't understand this at all, since as far as I
>  can tell I'm using thread-local variables and really all I'm doing
>  right now is assignments to them.  Unless, of course the struct rq
>  (from rq = cpu_rq(cpu);) could be being manipulated elsewhere, leading
>  to some sort of race condition...
>

can you post your modifications? I'd be much more easy to see what you
are doing...

thanks in advance.


>
>  Thanks,
>  -dan
>

-- 
Best regards,
Dmitry Adamushko
