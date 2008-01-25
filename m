Return-Path: <linux-kernel-owner+w=401wt.eu-S1760942AbYAYWAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760942AbYAYWAO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 17:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755598AbYAYV77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 16:59:59 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:30129 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbYAYV76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 16:59:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xgN3HF5iCzruGjDEyt6k0Q/WMd70rse51to2Ob/Xr9BR4mHiHD2TC5gIHg0BZl56xk2s6LD/inwhEvF7FkcrVbiJRSrDmAojZOZgI/EKdn3kj7Pn1y9bjFI3ZzLBprGeb/P/yxsIqWt/wN8Yld62ClN2tTkRokEBONAgvDKie6U=
Message-ID: <64bb37e0801251359k25abe9f8qe9e24a7a11acc29b@mail.gmail.com>
Date: Fri, 25 Jan 2008 22:59:55 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc8-mm1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080117023514.9df393cf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 17, 2008 11:35 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc8/2.6.24-rc8-mm1/

I'm still seeing my mystery-crash that I had since 2.6.24-rc3-mm2.

The crashed kernel was 2.6.24-rc8-mm1 with the following patches:

* personal fix for the "do_md_run returned -22"-problem
I'm just moving the analyze_sbs(mddev); above the test.

* git-sched-fix-bug_on.patch
* hotfix-libata-scsi-corruption.patch

The crash (captured via serial console):
Jan 25 21:40:01 treogen cron[6553]: (root) CMD (test -x
/usr/sbin/run-crons && /usr/sbin/run-crons )
Jan 25 20:40:44 treogen syslog-ng[4839]: I/O error occurred while
writing; fd='5', error='Input/output error (5)'
[ 1242.319555] ------------[ cut here ]------------
[ 1242.319557] kernel BUG at lib/list_debug.c:33!
[ 1242.319558] invalid opcode: 0000 [1] SMP
[ 1242.319560] last sysfs file:
/sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
[ 1242.319562] CPU 3
[ 1242.319563] Modules linked in:

The cursor on the receiving machine stayed after the : in the last
line, the crashed machine blinked caps lock and scroll lock.

I don't have a clue what the syslog-ng error is about or why this line
is one hour to early.
At 20:40 this kernel wasn't even build yet and syslog-ng started with
the correct timezone:
Jan 25 21:26:26 treogen syslog-ng[4839]: syslog-ng starting up; version='2.0.6'


As I'm seeing this bug during times of both network and hard disk
activity, could this be related to the problem discussed in the thread
"[PATCH rc8-mm1] hotfix libata-scsi corruption"? The line fixed in the
mm-hotfix seems to be to new to cause this in -rc3-mm2, but these
alignment problems seem to touch more than this and I'm not clear one
how old this might be.

(If this matters: The crashing system is running the smartd daemon
from smartmontools version 5.37)


I hope I will have time to try git-misc-tree on sunday...

Torsten
