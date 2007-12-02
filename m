Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbXLBQ7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbXLBQ7T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 11:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbXLBQ7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 11:59:10 -0500
Received: from smtp.cs.aau.dk ([130.225.194.6]:33862 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbXLBQ7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 11:59:09 -0500
Subject: Re: [PATCH 0/2] fix the long standing exec vs kill race
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071202151454.GA13180@tv-sign.ru>
References: <20071202151454.GA13180@tv-sign.ru>
Content-Type: multipart/mixed; boundary="=-bZmpHe12eMtxHwlFEEgQ"
Date: Sun, 02 Dec 2007 18:06:33 +0100
Message-Id: <1196615193.5698.8.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bZmpHe12eMtxHwlFEEgQ
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit


søn, 02 12 2007 kl. 18:14 +0300, skrev Oleg Nesterov:
> Depends on
> 	[PATCH] __group_complete_signal: fix coredump with group stop race
> 	http://marc.info/?l=linux-kernel&m=119653436116036
> 
> Needs review and testing.
> 
> Please comment, I think at least the idea is promising.
> 
I have an issue that sounds related, but I might be completely off. I
would expect the simple attached program to keep receiving the same
signal, i.e. respond to
	killall signal-exec -s SIGHUP

I tried your patches, but they didn't help.

Any ideas?


Simon Holm Thøgersen

--=-bZmpHe12eMtxHwlFEEgQ
Content-Disposition: attachment; filename=signal-exec.c
Content-Type: text/x-csrc; name=signal-exec.c; charset=utf-8
Content-Transfer-Encoding: 7bit

#include <signal.h>
#include <stdio.h>
#include <unistd.h>

static char **argv_;

static void handler(int signal)
{
	printf("got signal %d\n", signal);
	execv(argv_[0], argv_);
}

int main(int argc, char *argv[])
{
	printf("spawned\n");
	argv_ = argv;
	if (signal(SIGTERM, handler) == SIG_ERR)
		err(1, "could not set signal handler for SIGTERM");
	if (signal(SIGHUP, handler) == SIG_ERR)
		err(1, "could not set signal handler for SIGTERM");
	sleep(60);
	return 0;
}


--=-bZmpHe12eMtxHwlFEEgQ--

