Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbZHROkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbZHROkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 10:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZHROkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 10:40:46 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:40594 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbZHROkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 10:40:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19082.48492.202649.61984@stoffel.org>
Date: Tue, 18 Aug 2009 10:40:44 -0400
From: "John Stoffel" <john@stoffel.org>
To: "John Stoffel" <john@stoffel.org>
Cc: devzero@web.de, Martin Rogge <marogge@onlinehome.de>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.30.1-4 kernels freezes dual pentium-3 system
In-Reply-To: <19072.12751.294751.725334@stoffel.org>
References: <859079895@web.de>
	<19072.12751.294751.725334@stoffel.org>
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just a quick followup, I've been doing a git bisect run over the past
week or so trying to narrow this down.  It's slow, since the system
doesn't hang at any one point reliably.  So I far, here's my git log:

> git bisect log
git bisect start
# bad: [f4b9a988685da6386d7f9a72df3098bcc3270526] Merge branch
'for-linus' of git://git.infradead.org/ubi-2.6
git bisect bad f4b9a988685da6386d7f9a72df3098bcc3270526
# good: [8e0ee43bc2c3e19db56a4adaa9a9b04ce885cd84] Linux 2.6.29
git bisect good 8e0ee43bc2c3e19db56a4adaa9a9b04ce885cd84
# bad: [095342389e2ed8deed07b3076f990260ce3c7c9f] perf_counter, x86:
generic use of cpuc->active
git bisect bad 095342389e2ed8deed07b3076f990260ce3c7c9f
# bad: [095342389e2ed8deed07b3076f990260ce3c7c9f] perf_counter, x86:
generic use of cpuc->active
git bisect bad 095342389e2ed8deed07b3076f990260ce3c7c9f
# bad: [095342389e2ed8deed07b3076f990260ce3c7c9f] perf_counter, x86:
generic use of cpuc->active
git bisect bad 095342389e2ed8deed07b3076f990260ce3c7c9f
# bad: [095342389e2ed8deed07b3076f990260ce3c7c9f] perf_counter, x86:
generic use of cpuc->active
git bisect bad 095342389e2ed8deed07b3076f990260ce3c7c9f
# bad: [ebc8eca169be0283d5a7ab54c4411dd59cfb0f27] Merge branch 'next'
of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc


Part of what slows me down is having to apply my patch to a scsi
driver to ratelimit printks, otherwise I can spend over 30+ minutes
waiting just for the console to scoll an endless stream of messages
before it will continue to boot.  Or even longer.  :]

More as I get closer.
John
