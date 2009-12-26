Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbZLZBbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbZLZBbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 20:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757534AbZLZBbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 20:31:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34986 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757491AbZLZBbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 20:31:09 -0500
Message-ID: <4B356730.2080401@zytor.com>
Date: Fri, 25 Dec 2009 17:30:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Sergei Trofimovich <slyich@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
       Sergei Trofimovich <slyfox@inbox.ru>
Subject: Re: [PATCH] Kbuild: set LC_MESSAGES=C (as LC_CTYPE=C is)
References: <1261761235-9431-1-git-send-email-slyfox@inbox.ru>	<4B354C70.1060109@zytor.com> <adar5qizg6w.fsf@roland-alpha.cisco.com>
In-Reply-To: <adar5qizg6w.fsf@roland-alpha.cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25/2009 05:17 PM, Roland Dreier wrote:
> 
>  > The whole reason with only setting some LC_* to C was to be able to
>  > leave LC_MESSAGES intact, but it seems it breaks on too many real-life
>  > systems.
> 
>  > As such, I suggest we should set LC_ALL=C and get rid of the rest of it:
> 
> Seems unfortunate to lose localized error messages.  (Although in my
> en_US.UTF-8 case, all I get is non-ASCII quote characters)
> 

The whole problem is that for some people we lose *all* messages.  This
seems all very strange to me at all, but I guess it tweaks some internal
detail inside the glibc message library, sigh.

> This all started because of the awk invocation in arch/x86/lib.  Maybe
> the best idea would be to confine the locale monkeying to that one
> place?

Except that sed, etc. and even the shell itself have the same class of
problems.  Perl doesn't, since it has saner rules for how regular
expressions handle ranges.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

