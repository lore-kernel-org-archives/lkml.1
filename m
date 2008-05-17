Return-Path: <linux-kernel-owner+w=401wt.eu-S1759303AbYEQUGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303AbYEQUGr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 16:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758379AbYEQUGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 16:06:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:6180 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758755AbYEQUGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 16:06:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lrUVcBhfM8A9MG3eZoikfh/LMSZcW+m6RFEK/Qta/nQ/cqy6Tlfx4si02rpH6kb8aQr2j0zsdk7sgzSPZ6d/Z9EH/IOynyzAdYoALj/kL3FjUYVUpszYA4EftD0h/3a8jgBztZEDVPJbSDgKwYmmJqiSnjTHICCZ8eBgFTlMgiY=
Message-ID: <d4e708d60805171306n698192aas66b42a9468253448@mail.gmail.com>
Date: Sat, 17 May 2008 22:06:12 +0200
From: "koos vriezen" <koos.vriezen@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: mplayer v4l hangs in 2.6.25.2/4 (likely regression)
Cc: linux-kernel@vger.kernel.org, mchehab@infradead.org
In-Reply-To: <20080517123452.79b82be2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d4e708d60805170954n6b2044c7h306bc6cb76bf798d@mail.gmail.com>
	 <20080517111639.21a3e177@infradead.org>
	 <d4e708d60805171211q1a1966a3i78dc3dc98d275dd1@mail.gmail.com>
	 <20080517122640.2d15aeed@infradead.org>
	 <20080517123452.79b82be2@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/17 Arjan van de Ven <arjan@infradead.org>:

> > so.. bttv first takes "fh->cap.vb_lock" in vidiocgmbuf, then calls videobuf_mmap_setup(), and the first thing that does
is to also take fh->cap.vb_lock!  This isn't even an ABBA deadlock,
but a straight AA deadlock :)

Looks like I'm the only one actually running this code ;-)

> and here is an (untest) patch that should fix this problem:
> Koos, can you apply this to your kernel tree and report back if this
> fixes your deadlock?

patching file drivers/media/video/bt8xx/bttv-driver.c
patching file drivers/media/video/videobuf-core.c
Hunk #1 succeeded at 335 (offset 4 lines).
Hunk #2 succeeded at 1093 (offset -36 lines).
patching file include/media/videobuf-core.h
Hunk #1 succeeded at 227 (offset -10 lines).

Deadlock is gone, only mplayer fails to unmute the audio. Again the
Xvideo player works okay (with audio).
Hmm, using v4l2 (mplayer .. -tv noaudio:driver=v4l2:devic..) works
with audio now (used to be the other way around). I can live with
that.

Thanks for your help,
Koos
