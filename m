Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbYJFKs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbYJFKs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 06:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbYJFKst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 06:48:49 -0400
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:51764 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751788AbYJFKss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 06:48:48 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: <PING> Re: [patch x86/core] x86: allow number of additional hotplug  CPUs to be set at compile time
To: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Reply-To: 7eggert@gmx.de
Date: Mon, 06 Oct 2008 12:59:18 +0200
References: <bijiX-86S-5@gated-at.bofh.it> <bisvP-3es-3@gated-at.bofh.it> <biC2k-7cR-17@gated-at.bofh.it> <biCbU-7lA-15@gated-at.bofh.it> <biCOy-8ep-3@gated-at.bofh.it> <biD7T-5N-1@gated-at.bofh.it> <bjiEh-2MC-21@gated-at.bofh.it> <bjnXc-1ec-11@gated-at.bofh.it> <bjz2s-78A-13@gated-at.bofh.it> <bjDfK-40E-19@gated-at.bofh.it> <bjDIN-4L8-31@gated-at.bofh.it> <bjEbU-5eX-19@gated-at.bofh.it> <bjIIi-2Oi-1@gated-at.bofh.it> <bjJOk-49Q-5@gated-at.bofh.it> <bjKAv-5bK-17@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1Kmno6-0003es-Te@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> wrote:

> additional_cpus is used to tell Linux that there are more (or less)
> CPUs hotpluggable than the BIOS declares at boot time. This is needed
> because the way the BIOS is declaring it is a Linux extension, not standard.
> But even if it was standard it would be good policy to be able
> to override it because as we all know BIOS can be wrong, as in
> declare far too many.

I don't have a machine with pluggable CPUs, but I'd imagine if you'd take out
some CPUs, the number of additional CPUs you can plug in will increase by the
same number (forcing me to change the kernel command lince if I do), while the
number of slots (and the number of possible CPUs) stays the same unless
somebody offers a new kind of CPU card. Therefore, I'd expect "maxcpus=" to be
the only interface I want for this purpose. Put in a value bigger than the
amount plugged in -> voila.

OTOH, looking at Thomas' patch, I'd guess it would not work as expected ...
and looking at the code seems to confirm this. Besides that, I'd possibly
want a way to limit the number of online CPUs at boot saying something like
"onlinecpus=", which would not limit the number of CPUs I can plug in.

