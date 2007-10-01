Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124AbXJABPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbXJABPj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 21:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbXJABPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 21:15:32 -0400
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1697 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbXJABPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 21:15:31 -0400
X-Greylist: delayed 974 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Sep 2007 21:15:31 EDT
From: "Miquel van Smoorenburg" <miquels@cistron.nl>
Subject: Re: F_DUPFD_CLOEXEC implementation
References: <200709281734.l8SHYTmd027235@devserv.devel.redhat.com> <200709300131.49320.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: mikevs@n2o.xs4all.nl (Miquel van Smoorenburg)
Date: 01 Oct 2007 00:59:14 GMT
Message-ID: <47004662$0$241$e4fe514c@news.xs4all.nl>
X-Trace: 1191200354 news.xs4all.nl 241 [::ffff:194.109.0.112]:41092
X-Complaints-To: abuse@xs4all.nl
In-Reply-To: <200709300131.49320.vda.linux@googlemail.com>
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <200709300131.49320.vda.linux@googlemail.com>,
Denys Vlasenko  <vda.linux@googlemail.com> wrote:
>Hi Ulrich,
>
>On Friday 28 September 2007 18:34, Ulrich Drepper wrote:
>> One more small change to extend the availability of creation of
>> file descriptors with FD_CLOEXEC set.  Adding a new command to
>> fcntl() requires no new system call and the overall impact on
>> code size if minimal.
>
>Tangential question: do you have any idea how userspace can
>safely do nonblocking read or write on a potentially-shared fd?
>
>IIUC, currently it cannot be done without races:
>
>old_flags = fcntl(fd, F_GETFL);
>...other process may change flags!...
>fcntl(fd, F_SETFL, old_flags | O_NONBLOCK);
>read(fd, ...)
>...other process may see flags changed under its feet!...
>fcntl(fd, F_SETFL, old_flags);
>
>Can this be fixed?

This is for sockets, right ? Just use revc() instead of read().

	n = recv(filedesc, buffer, buflen, MSG_DONTWAIT);

.. is equivalent to setting O_NONBLOCK. See "man recv".

Mike.
