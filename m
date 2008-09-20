Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbYITXvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbYITXvT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 19:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbYITXvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 19:51:10 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:44023 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbYITXvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 19:51:10 -0400
Message-ID: <48D58C6B.9000403@skyrush.com>
Date: Sat, 20 Sep 2008 17:51:07 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080727)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hpa@zytor.com
Subject: Re: [PATCH] Fix backspace on wrapped lines in console (virtual terminal)
References: <48D5240D.7070701@skyrush.com> <20080920173822.51794923@lxorguk.ukuu.org.uk>
In-Reply-To: <20080920173822.51794923@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Sat, 20 Sep 2008 10:25:49 -0600
> Joe Peterson <joe@skyrush.com> wrote:
> 
>> Attached is a patch that fixes virtual terminal problems when backspace
>> is used on wrapped lines (see patch text for the specific issues).  The
>> issues can be demonstrated by trying two things in the console (vt):
> 
> I would need to power up my vt420 to check (yes I have one lurking in a
> corner!) but I have a feeling the current behaviour (not going up a line)
> is correct for ansi type terminals.

One more thought about this:

xterm has a "private mode 45", which turns on reverseWrap, allowing
backspace to wrap.  This is similar to mode 7 (supported on xterm and
vt), which is DEVAWM (auto wrap mode).

I agree that hard-coding backspace/reverse wrap would likely be wrong
(even though it looks like some terminal emulators I've seen, like
"screen" add the feature), but would it be appropriate to add mode 45 to
vt, allowing reverse wrap as an option?

Also note that vt enables DEVAWM (mode 7) by default, whereas the vt100
docs say that it is off by default.  Since reverse wrap is probably
almost always useful for general Linux in the console, should it also be
on by default if we were to add that option?

						-Joe
