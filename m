Return-Path: <linux-kernel-owner+w=401wt.eu-S1756200AbXJATDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbXJATDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 15:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbXJATDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 15:03:00 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:22510 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbXJATC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 15:02:59 -0400
X-Greylist: delayed 573 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Oct 2007 15:02:59 EDT
Message-ID: <47014224.4030204@msgid.tls.msk.ru>
Date: Mon, 01 Oct 2007 22:53:24 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Denys Vlasenko <vda.linux@googlemail.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: F_DUPFD_CLOEXEC implementation
References: <200709281734.l8SHYTmd027235@devserv.devel.redhat.com> <200710010058.49242.vda.linux@googlemail.com> <Pine.LNX.4.64.0709301709490.19355@alien.or.mcafeemobile.com> <200710011107.15846.vda.linux@googlemail.com> <20071001181648.GB8181@ftp.linux.org.uk>
In-Reply-To: <20071001181648.GB8181@ftp.linux.org.uk>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Mon, Oct 01, 2007 at 11:07:15AM +0100, Denys Vlasenko wrote:
>> Also attached is ndelaytest.c which can be used to test that
>> send(MSG_DONTWAIT) indeed is failing with EAGAIN if write would block
>> and that other processes never see O_NONBLOCK set.
>>
>> Comments?
> 
> Never send patches during or approaching hangover?
> 	* it's on a bunch of cyclic lists.  Have its neighbor
> go away while you are doing all that crap => boom
> 	* there's that thing call current position...  It gets buggered.
> 	* overwriting it while another task might be in the middle of
> syscall involving it => boom
> 	* non-cooperative tasks reading *in* *parallel* from the same
> opened file are going to have a lot more serious problems than agreeing
> on O_NONBLOCK anyway, so I really don't understand what the hell is that for.

Good summary... ;)

But for the last part of the last item - sometimes, definitely more than
once, I wondered why there's no equivalent to recv(MSG_DONTWAIT) for
non-sockets -- why for sockets it's as simple as adding an option (a
single bit), while for all the rest it requires two fcntl calls...
Sometimes it's handy. ;)

Not that I'm arguing for or against such a feature anyway..

/mjt
