Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbZH1MxC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbZH1MxC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 08:53:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbZH1MxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 08:53:01 -0400
Received: from mx01.bfk.de ([193.227.124.2]:49881 "EHLO mx01.bfk.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbZH1MxA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 08:53:00 -0400
To: Eric Blake <ebb9@byu.net>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bug-coreutils@gnu.org, bug-gnulib@gnu.org,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] open: introduce O_NOSTD
References: <4A9285FC.8000606@byu.net>
	<1251202593-3676-1-git-send-email-ebb9@byu.net>
	<alpine.DEB.2.00.0908251420190.18518@makko.or.mcafeemobile.com>
	<4A968FF8.8050109@byu.net> <82k50puxx8.fsf@mid.bfk.de>
	<4A97D16D.5060003@byu.net>
From: Florian Weimer <fweimer@bfk.de>
Date: Fri, 28 Aug 2009 12:52:57 +0000
In-Reply-To: <4A97D16D.5060003@byu.net> (Eric Blake's message of "Fri\, 28 Aug 2009 06\:45\:33 -0600")
Message-ID: <82ocq0p0ba.fsf@mid.bfk.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Blake:

> Your version fails to clear the cloexec bit of the final fd if the
> original caller didn't request O_CLOEXEC.

Okay, but you can fix that in a race-free manner (but I thought that
this was implied by open_safer).

> If the caller requested O_CLOEXEC, then your version takes 3, 5, or
> 7 syscalls depending on how many std fds were closed, while my
> version takes 3 syscalls regardless of how many std fds were closed.

I really don't see a way around that.  You can't pick a descriptor and
hope that it's unused.

> Also, your suggestion has a definite race in that you are calling
> open() multiple times rather than cloning an existing fd after the
> first open(), such that another process could alter which file is
> visited between your first and last open().

Sure, but this is an unobservable differen.ce

-- 
Florian Weimer                <fweimer@bfk.de>
BFK edv-consulting GmbH       http://www.bfk.de/
Kriegsstraﬂe 100              tel: +49-721-96201-1
D-76133 Karlsruhe             fax: +49-721-96201-99
