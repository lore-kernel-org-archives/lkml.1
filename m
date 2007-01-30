Return-Path: <linux-kernel-owner+w=401wt.eu-S964907AbXA3Dso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964907AbXA3Dso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 22:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964982AbXA3Dso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 22:48:44 -0500
Received: from old-tantale.fifi.org ([64.81.251.130]:33688 "EHLO
	tantale.fifi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964907AbXA3Dsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 22:48:43 -0500
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jan 2007 22:48:43 EST
To: Denis Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: O_NONBLOCK setting "leak" outside of a process??
References: <200701272152.11087.vda.linux@googlemail.com>
Mail-Copies-To: nobody
From: Philippe Troin <phil@fifi.org>
Date: 29 Jan 2007 19:40:50 -0800
In-Reply-To: <200701272152.11087.vda.linux@googlemail.com>
Message-ID: <87bqkhuqpp.fsf@tantale.fifi.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Vlasenko <vda.linux@googlemail.com> writes:

> Hi,
> 
> I am currently on Linux 2.6.18, x86_64.
> I came across strange behavior while working on one
> of busybox applets. I narrowed it down to these two
> trivial testcases:
> 
> #include <unistd.h>
> #include <fcntl.h>
> int main() {
>         fcntl(0, F_SETFL, fcntl(0, F_GETFL, 0) | O_NONBLOCK);
>         return 0;
> }
> 
> #include <unistd.h>
> #include <fcntl.h>
> int main() {
>         fcntl(0, F_SETFL, fcntl(0, F_GETFL, 0) & ~O_NONBLOCK);
>         return 0;
> }
> 
> If I run "nonblock" in Midnight Commander in KDE's Konsole,
> screen redraw starts to work ~5 times slower. For example,
> Ctrl-O ("show/hide panels" in MC) takes ~0.5 sec to redraw.
> This persists after the program exist (which it
> does immediately as you see).
> Running "block" reverts things to normal.
> 
> I mean: how can O_NONBLOCK _issued in a process which
> already exited_ have any effect whatsoever on MC or Konsole?
> They can't even know that it did it, right?
> 
> Either I do not know something subtle about Unix or some sort
> of bug is at work.

Because they all share the same stdin file descriptor, therefore they
share the same file descriptor flags?

Phil.
