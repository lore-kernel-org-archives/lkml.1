Return-Path: <linux-kernel-owner+w=401wt.eu-S1752980AbZEYMWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980AbZEYMWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 08:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbZEYMWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 08:22:30 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:52971 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbZEYMW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 08:22:29 -0400
From: Goswin von Brederlow <goswin-v-b@web.de>
To: Alberto Bertogli <albertito@blitiri.com.ar>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       linux-raid@vger.kernel.org, agk@redhat.com, neilb@suse.de
Subject: Re: [RFC PATCH] dm-csum: A new device mapper target that checks data integrity
References: <20090521161317.GU1376@blitiri.com.ar>
Date: Mon, 25 May 2009 14:22:23 +0200
In-Reply-To: <20090521161317.GU1376@blitiri.com.ar> (Alberto Bertogli's
	message of "Thu, 21 May 2009 13:13:17 -0300")
Message-ID: <87my91qsn4.fsf@frosties.localdomain>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.22 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX1+bPSGN/RmMmeGNTapy6yqx9NPMwIG9wh9U1lWn
	AuF3TBGbRL/c3UZe3d0asCo1WEPUOCA+tc4OPgBeyXituCKAeN
	yV0doTvl0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alberto Bertogli <albertito@blitiri.com.ar> writes:

> Hi!
>
> I'm writing this device mapper target that stores checksums on writes and
> verifies them on reads.
>
> It's not widely tested, but you can run mke2fs on it and do basic file
> operations. The to-do list is still large, and most of it can be found within
> the code.
>
> To test it, you will need to format the device using the (very rough) attached
> tool, and then create the dm device with something like:
>
> 	echo 0 $SIZE csum $REALDEVICE 0 | dmsetup create $NAME
>
>
> I think it can be useful for people who want to detect data corruption and are
> either using the block layer directly or a filesystem that doesn't check data
> integrity (which are most, if not all, of the popular ones today). Maybe it
> could also be used for testing the bio-integrity extensions, although at the
> moment it's completely independent and I haven't looked much, but it's on my
> to-do list.
>
> It does NOT pretend to be useful for consistency checks for security purposes.
> Use something else if you do not want someone evil tampering with your data.
>
>
> Comments are obviously welcome. There are also some questions embedded in the
> code, if anyone cares to answer any of them, I'd really appreciate it.
>
> Thanks a lot,
> 		Alberto

How does that behave on crashes? Will checksums be out of sync with data?
Will pending blocks recalculate their checksum?

MfG
        Goswin
