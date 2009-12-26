Return-Path: <linux-kernel-owner+w=401wt.eu-S1751620AbZLZUFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbZLZUFR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 15:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbZLZUFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 15:05:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48036 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbZLZUFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 15:05:14 -0500
Message-ID: <4B366C69.9010700@zytor.com>
Date: Sat, 26 Dec 2009 12:04:57 -0800
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
> This all started because of the awk invocation in arch/x86/lib.  Maybe
> the best idea would be to confine the locale monkeying to that one
> place?
> 

It is also possible that setting only LC_COLLATE will solve the most
fundamental problem, which is the one of character ranges.  LC_COLLATE
probably will interfere less with LC_MESSAGES than the setting of LC_CTYPE.

It's still bloody broken that glibc malfunctions like that for an
LC_MESSAGES/LC_CTYPE intentional mismatch, but, sigh, that's glibc for you.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

