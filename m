Return-Path: <linux-kernel-owner+w=401wt.eu-S932418AbYBZV72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbYBZV72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763253AbYBZV7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:59:09 -0500
Received: from styx.suse.cz ([82.119.242.94]:52153 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764096AbYBZV7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:59:08 -0500
Date: Tue, 26 Feb 2008 22:59:07 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?UTF-8?Q?Szekeres_Istv=C3=A1n?= <szekeres@iii.hu>
cc: linux-kernel@vger.kernel.org
Subject: Re: kernel losing printk messages?
In-Reply-To: <f4fe1c2a0802261344xdbee78j730c9011b8b63aa7@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802262256480.30955@jikos.suse.cz>
References: <f4fe1c2a0802261309s17aaf082w14525c1e2f3af2f@mail.gmail.com> 
 <f4fe1c2a0802261314i5c4c5738y2a3f0e1c8748ee60@mail.gmail.com> 
 <Pine.LNX.4.64.0802262233290.30955@jikos.suse.cz>
 <f4fe1c2a0802261344xdbee78j730c9011b8b63aa7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="336216065-621930440-1204063147=:30955"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--336216065-621930440-1204063147=:30955
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 26 Feb 2008, Szekeres Istv=E1n wrote:

> >  I guess in dmesg the output is also corrupted, right?
> Interesting. Even after a dmesg -c -s 1000000 it contains only the end
> of the story. This is the beginning of the dmesg output:

Probably your kernel ring buffer is too small (log_buf_len boot=20
parameter).

> rusalka:~% dmesg | head
> input.c: Mapping: Consumer.0230 ---> IGNORED
> [85080.775297] drivers/hid/hid-input.c: Mapping: Consumer.0231 ---> IGNOR=
ED
> [85080.775302] drivers/hid/hid-input.c: Mapping: Consumer.0232 ---> IGNOR=
ED
> [85080.775308] drivers/hid/hid-input.c: Mapping: Consumer.0233 ---> Key.S=
crollUp
> [85080.775314] drivers/hid/hid-input.c: Mapping: Consumer.0234 --->
> Key.ScrollDown
> So the first line is corrupted.=20

It is very probably just because it didn't fit into the ring buffer.

> In the remaining of the output (total=3D220 lines) I cannot see the=20
> evidence of corruption.

So the corruption you see in your /var/log is probably just userspace=20
issue (syslogd/klogd not grabbing lines coming too fast for too long?).=20
Still, it seems to work for me here.

Thanks,

--=20
Jiri Kosina
SUSE Labs
--336216065-621930440-1204063147=:30955--
