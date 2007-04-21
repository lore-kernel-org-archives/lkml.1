Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbXDUVCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbXDUVCX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 17:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbXDUVCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 17:02:23 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50632 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbXDUVCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 17:02:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, serue@us.ibm.com,
       viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [patch 7/8] allow unprivileged mounts
References: <20070420102532.385211890@szeredi.hu>
	<20070420102652.075606533@szeredi.hu>
	<20070421005513.e230aa88.akpm@linux-foundation.org>
	<m1bqhhked1.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.61.0704211743100.9989@yvahk01.tjqt.qr>
	<m1zm51is2h.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.61.0704211905230.9989@yvahk01.tjqt.qr>
Date: Sat, 21 Apr 2007 15:00:16 -0600
In-Reply-To: <Pine.LNX.4.61.0704211905230.9989@yvahk01.tjqt.qr> (Jan
	Engelhardt's message of "Sat, 21 Apr 2007 19:10:55 +0200 (MEST)")
Message-ID: <m17is5igtb.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@linux01.gwdg.de> writes:

> On Apr 21 2007 10:57, Eric W. Biederman wrote:
>>
>>> tmpfs!
>>
>>tmpfs is a possible problem because it can consume lots of ram/swap. 
>>Which is why it has limits on the amount of space it can consume. 
>
> Users can gobble up all RAM and swap already today. (Unless they are
> confined into an rlimit, which, in most systems, is not the case.)
> And in case /dev/shm exists, they can already fill it without running
> into an rlimit early.

There are systems that care about rlimits and there is strong intersection
between caring about rlimits and user mounts.  Although I do agree that
it looks like we have gotten lazy with the default mount options for
/dev/shm.

Going a little farther any filesystem that is safe to put on a usb
stick and mount automatically should ultimately be safe for unprivileged
mounts as well.

So it looks to me like ultimately most of the common filesystems will actually
be safe for non-privileged mounting.

Regardless this looks like an important discussion as soon as we have the
glitches out of the non-privileged mount code.

Eric
