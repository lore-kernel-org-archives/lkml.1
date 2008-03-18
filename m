Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbYCRHYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbYCRHYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 03:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbYCRHYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 03:24:07 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:24117 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbYCRHYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 03:24:06 -0400
Message-ID: <47DF6E13.5050709@msgid.tls.msk.ru>
Date: Tue, 18 Mar 2008 10:24:03 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Andreas Schwab <schwab@suse.de>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: /dev/stdin, symlinks & permissions
References: <47DEFE26.80101@msgid.tls.msk.ru> <jeabkwaou7.fsf@sykes.suse.de>
In-Reply-To: <jeabkwaou7.fsf@sykes.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab wrote:
> Michael Tokarev <mjt@tls.msk.ru> writes:
> 
>>   # ls -l /dev/pts/0
>>   crw--w---- 1 root tty 136, 0 Mar 18 02:19 /dev/pts/0
>>
>> So far so good.  Now, I change uid to something else, --
>> doing su(8) to "mjt".  /proc/self changed obviously,
>> but stdin &Co is still here, and points to the same
>> /dev/pts/0.  But *its* permissions/ownership did not
>> change!  So now I can't, for example,
>>
>>  $ echo x > /dev/stdout
>>  bash: /dev/stdout: Permission denied
>>
>> which is quite unexpected - I for one expect /dev/stdout
>> to work the way very similar to /dev/tty, to mean "current
>> standard output regardless of any permissions etc".
> 
> This has nothing to do with /dev/stdout.  Your terminal simply does not
> allow access by anyone except user root or group tty.  You need to open
> it up first, or mount /dev/pts with broader permissions (which is a bad
> idea however).

No, you don't understand.  It has nothing to do with permissions
to the actual file /dev/stdin refers to, be it a tty or something
else.

In the exact same situation, I don't have to do anything with
/dev/tty (which refers to the same tty at the end) - it
Just Works (tm).  Ditto on Solaris for example, --
/dev/stdin etc Just Works too.  But not on Linux.

Without digging into implementation details (in this case it's
the fact that /dev/stdin in linux is implemented using a symlink
to - f.e. - /dev/tty/0 etc), I expect /dev/stdin to always work
as far as filedescriptor 0 is open, regardless of any permissions
on the actual tty (if it's a tty in the first place, which is
not necessary the case) -- exactly the same as /dev/tty works.

It's more:  I can redirect stdout of a process to some file,
and at that point /dev/stdout will return ENOENT on open.

The question is:

Are /dev/stdin &Co on linux are just convenience symlinks to
know where your std* files are (if so, why they're in /dev
and why they're so INconvenient - so many levels of symlinks), --
ie, the only thing I can do with them is ls/readlink them,
or are they supposed to actually WORK, ie, I'm able to open
them, as on other systems?

Thanks.

/mjt
