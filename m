Return-Path: <linux-kernel-owner+w=401wt.eu-S932394AbXBULd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394AbXBULd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 06:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932417AbXBULd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 06:33:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932394AbXBULd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 06:33:56 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <45DC184C.3080600@hitachi.com> 
References: <45DC184C.3080600@hitachi.com>  <45DAC32B.4030603@hitachi.com> <45D5B483.3020502@hitachi.com> <45D5B2E3.3030607@hitachi.com> <20368.1171638335@redhat.com> <18826.1171969097@redhat.com> 
To: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
Cc: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Robin Holt <holt@sgi.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: Re: [PATCH 3/4] coredump: ELF-FDPIC: enable to omit anonymous shared memory 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 21 Feb 2007 11:33:31 +0000
Message-ID: <8347.1172057611@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kawai, Hidehiro <hidehiro.kawai.ez@hitachi.com> wrote:

> Is coredump_setting_sem a global semaphore?  If so, it prevents concurrent
> core dumping.

No, it doesn't.  Look again:

	int do_coredump(long signr, int exit_code, struct pt_regs * regs)
	{
		<setup vars>

 >>>>		down_read(&coredump_settings_sem);

> Additionally, while some process is dumped, writing to
> coredump_omit_anon_shared of unrelated process will be blocked.

Yes, but that's probably reasonable.  How likely (a) is a process to coredump,
and (b) is a coredump to occur simultaneously with someone altering their
settings?

David
