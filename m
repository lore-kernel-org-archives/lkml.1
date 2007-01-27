Return-Path: <linux-kernel-owner+w=401wt.eu-S1752390AbXA0UyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbXA0UyY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 15:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbXA0UyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 15:54:24 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:8417 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbXA0UyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 15:54:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=iv8xcDhsc84DboDJF1Zm5fA4/tHQ5CaEPa56RIeIHwP9ks5mYzAVaov+LMwujk8gB+Kcg0ryDhwLwstR9dc+rl/owu1Bcrdo6z1rnFv6qlSXxdvNtffb1J4ehlVxC8WdLatmEOyv3N5qFvShZ3m4Lerf6HLir/Sxlaw0y8bJA0k=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: O_NONBLOCK setting "leak" outside of a process??
Date: Sat, 27 Jan 2007 21:52:11 +0100
User-Agent: KMail/1.8.2
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701272152.11087.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am currently on Linux 2.6.18, x86_64.
I came across strange behavior while working on one
of busybox applets. I narrowed it down to these two
trivial testcases:

#include <unistd.h>
#include <fcntl.h>
int main() {
        fcntl(0, F_SETFL, fcntl(0, F_GETFL, 0) | O_NONBLOCK);
        return 0;
}

#include <unistd.h>
#include <fcntl.h>
int main() {
        fcntl(0, F_SETFL, fcntl(0, F_GETFL, 0) & ~O_NONBLOCK);
        return 0;
}

If I run "nonblock" in Midnight Commander in KDE's Konsole,
screen redraw starts to work ~5 times slower. For example,
Ctrl-O ("show/hide panels" in MC) takes ~0.5 sec to redraw.
This persists after the program exist (which it
does immediately as you see).
Running "block" reverts things to normal.

I mean: how can O_NONBLOCK _issued in a process which
already exited_ have any effect whatsoever on MC or Konsole?
They can't even know that it did it, right?

Either I do not know something subtle about Unix or some sort
of bug is at work.

Any advice?
--
vda
