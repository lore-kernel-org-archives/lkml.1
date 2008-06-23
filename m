Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbYFWKvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbYFWKvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 06:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbYFWKvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 06:51:15 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:21229 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbYFWKvO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 06:51:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=a/RAqrQQ8GgC4sni4K+iBff8KCbUIqNy4r/qho/tekBSM6SlWW3v1z1MNlwVBdPfLC
         mkjDTUg4rTEZkff69LrOR2PAceFiBvYxUOFECcYUMGk6U4D2QOjnIl2X+kviHz1Ysova
         e9kAu1tLckMI5O3LkHGQVD5+ay+7Q0y7F80N8=
Message-ID: <cfd18e0f0806230351nd9eb54ei5e87734291ced9be@mail.gmail.com>
Date: Mon, 23 Jun 2008 12:51:11 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Laurent Vivier" <Laurent.Vivier@bull.net>
Subject: Re: /proc 2.6.24 changes for guest CPU accounting
Cc: "Michael Kerrisk" <mtk.manpages@gmail.com>,
       "Samuel Thibault" <samuel.thibault@ens-lyon.org>, ap@zip.com.au,
       lkml <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Christian Borntraeger" <borntraeger@de.ibm.com>
In-Reply-To: <1214210925.3838.7.camel@frecb07144>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <485DFFB4.3080008@gmail.com> <1214210925.3838.7.camel@frecb07144>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 10:48 AM, Laurent Vivier
<Laurent.Vivier@bull.net> wrote:
> Le dimanche 22 juin 2008 à 09:31 +0200, Michael Kerrisk a écrit :
>> Hi Laurent,
>
> Hi Michael,
>
>> A note and patch from Samuel alerted me to your commits
>> 9ac52315d4cf5f561f36dabaf0720c00d3553162 and
>> 5e84cfde51cf303d368fcb48f22059f37b3872de, which in 2.6.24 changed /proc/stat
>> and /proc/PID/stat.  Would you please CC me on kernel-userspace interface
>> changes, so that they have a chance of getting documented in man-pages.
>>
>> (I see that Andrew P tried to get something added to
>> Documentation/filesystems/proc.txt, but that doesn't seem to have made it in.)
>>
>> Below is a patch against the proc.5 man page by Samuel and I to document these
>> changes.  Do the changes look okay to you?  The first part is the change for
>> /proc/<pid>/stat, and the other is for /proc/stat.
>
> Thank you for that. It seems correct to me (except a typo).
>
> You must also notes that "user time" includes "guest time", if you want
> real "user time" you must subtract "guest time".
> The "guest time" is included in "user time" to not loose it when the
> "reader" is not aware of the "guest time".

Hi Laurent (and Christian)

So, I just want to confirm.  You are saying that guest_time and
cguest_time are respectively also included in the following fields

              utime %lu
                     The number of jiffies that this process has  been
                     scheduled in user mode.

              [...]

              cutime %ld
                     The number of jiffies that this process's waited-
                     for  children  have  been scheduled in user mode.
                     (See also times(2).)

Right?

(In fs/proc/array.c, those are the two lines from

                cputime_to_clock_t(utime),
                cputime_to_clock_t(cutime),
)

Cheers,

Michael
