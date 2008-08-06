Return-Path: <linux-kernel-owner+w=401wt.eu-S1762775AbYHFUR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762775AbYHFUR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758331AbYHFURd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:17:33 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:38700 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979AbYHFURb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:17:31 -0400
Message-ID: <489A06D9.1080600@skyrush.com>
Date: Wed, 06 Aug 2008 14:17:29 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080727)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: tty: ctrl-c not always echoed, especially under load
References: <48977C96.2090005@skyrush.com> <20080805001129.72d06e60@lxorguk.ukuu.org.uk>
In-Reply-To: <20080805001129.72d06e60@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> If the output buffer is full then echoed characters/^C etc will vanish the
> way n_tty implements its buffering internally. It's always worked that
> way.

One more observation:

In Linux, try this:

# cat > foo
hi^Sthere^Q
^D

(in other words, during the cat into "foo", type "hi", hit ^S, then type
"there", then hit ^Q, then, on the next line, ^D to end the file)

Note that the "there" does not appear after hitting ^Q, but it does
appear in the file.  So the characters were accepted, but they were not
echoed (not even saved for echo when the terminal is restarted).

This behavior differs from that of FreeBSD (just tried it for fun -
haven't tried other Unix's yet).  I have noticed other times that the
echo seems to get lost while the tty is stopped.  Not sure if all this
is related, but something seems amiss.  Thoughts?

					Thanks, Joe
