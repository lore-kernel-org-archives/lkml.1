Return-Path: <linux-kernel-owner+w=401wt.eu-S1762830AbZD1QBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762830AbZD1QBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762771AbZD1QBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:01:17 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45328 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762786AbZD1QBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:01:16 -0400
To: teheo@suse.de
CC: linux-kernel@vger.kernel.org, greg@kroah.com, miklos@szeredi.hu,
       tiwai@suse.de, fuse-devel@lists.sourceforge.net
In-reply-to: <49E3F91E.4000801@suse.de> (message from Tejun Heo on Tue, 14 Apr
	2009 11:46:54 +0900)
Subject: Re: [ANNOUNCE] OSS Proxy 1.2 using CUSE
References: <48B6F711.1040604@kernel.org> <49E3F91E.4000801@suse.de>
Message-Id: <E1Lypk4-0004it-BA@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 28 Apr 2009 18:01:08 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From the README:

| ALSA contains OSS emulation but sadly the emulation is behind
| multiplexing layer (which is in userland) which means that if your
| sound card doesn't support multiple audio streams, only either one of
| ALSA or OSS interface would be usable at any given moment.

This seems to imply (and I was hoping very much) that this won't be a
limitation of a CUSE based OSS Proxy.  But at the moment I'm finding
that while ossp is doing some playback other ALSA apps cannot start
playback and vice versa.

In fact if something else is playing though ALSA and I start a
playback through ossp, then ossp will print some errors, return EIO
and get into a bad state, that it recoveres from only by starting the
playback twice more (after stopping the other playback through ALSA).

ossp-padsp[mszeredi:24123]  ERR: pa_stream_write() failed (Connection terminated)
osspd  ERR: failed to read_fill 16 bytes from fd 7 (Connection reset by peer)
osspd WARN: S[1/24122] communication with slave failed (can't read reply: Connection reset by peer)
E: socket-client.c: socket(): Address family not supported by protocol
E: context.c: waitpid(): No child processes
ossp-padsp[mszeredi:24130]  ERR: failed to connect context, state=5 (Bad state)

Thanks,
Miklos
