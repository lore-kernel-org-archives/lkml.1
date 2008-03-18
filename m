Return-Path: <linux-kernel-owner+w=401wt.eu-S939195AbYCSXru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939195AbYCSXru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762579AbYCSWQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:16:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:49645 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940082AbYCSWQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:16:14 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH 4/5] don't panic if /sbin/init exits or killed
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Laurent Riffard <laurent.riffard@free.fr>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Tue, 18 Mar 2008 18:41:18 +0100
References: <a83rs-N7-9@gated-at.bofh.it> <a89wR-8k4-3@gated-at.bofh.it> <a8a9t-1pV-21@gated-at.bofh.it> <a8aCw-2hv-31@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1JbfoM-0003fj-Qz@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19fta4vRxn0CxU9WKbvqYnE7c+Kqb0txqt8dDq
 EdSSUuhdXzEQX4LO0cIttH8MF8TsyyTffVlJxp6Di01qhXeDqD
 BXEb0UMlkmG3zCInKX7pw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath <roland@redhat.com> wrote:

>> But panic() isn't better? It doesn't provide any useful info.
> 
> It is not misleading in the same way.  It's clear that going to look at the
> kernel source is not the place to find the root of the problem.
> 
>> Well, I think the generic "if we have a chance to survive, we should try
>> to survive" rule is good.
>> 
>> If the boot init dies, at least the admin has a chance to figure out what
>> has happened, and -o remount,ro /.
> 
> For me and you, I agree.  I think the common case is that there is no admin
> prepared to do any such thing, but just someone expecting a reboot to fix
> things and preferring that a failing system reboot itself in the middle of
> the night rather than wedge.

I think the common case is repairing a system using init=/bin/sh, and
forgetting to not log out instead of fscking the filesystem after the panic.
Rebooting on panic= is fine, but not skipping the umount/sync stages.

