Return-Path: <linux-kernel-owner+w=401wt.eu-S1751211AbXBULyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211AbXBULyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 06:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750989AbXBULyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 06:54:44 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34775 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751216AbXBULyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 06:54:43 -0500
Date: Wed, 21 Feb 2007 05:54:36 -0600
From: Robin Holt <holt@sgi.com>
To: David Howells <dhowells@redhat.com>
Cc: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Robin Holt <holt@sgi.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: Re: [PATCH 3/4] coredump: ELF-FDPIC: enable to omit anonymous shared memory
Message-ID: <20070221115436.GA31332@lnx-holt.americas.sgi.com>
References: <45DC184C.3080600@hitachi.com> <45DAC32B.4030603@hitachi.com> <45D5B483.3020502@hitachi.com> <45D5B2E3.3030607@hitachi.com> <20368.1171638335@redhat.com> <18826.1171969097@redhat.com> <8347.1172057611@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8347.1172057611@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 11:33:31AM +0000, David Howells wrote:
> Kawai, Hidehiro <hidehiro.kawai.ez@hitachi.com> wrote:
> 
> > Is coredump_setting_sem a global semaphore?  If so, it prevents concurrent
> > core dumping.
> 
> No, it doesn't.  Look again:
> 
> 	int do_coredump(long signr, int exit_code, struct pt_regs * regs)
> 	{
> 		<setup vars>
> 
>  >>>>		down_read(&coredump_settings_sem);
> 
> > Additionally, while some process is dumped, writing to
> > coredump_omit_anon_shared of unrelated process will be blocked.
> 
> Yes, but that's probably reasonable.  How likely (a) is a process to coredump,
> and (b) is a coredump to occur simultaneously with someone altering their
> settings?

And (c) altering the setting during a core dump going to produce an
unusable core dump.  I don't think the locking is that difficult to add
and it just makes sense.  I would venture a guess that it will take less
time to actually do the locking than to continue arguing it is not needed
when it clearly appears it is needed for even a small number of cases.

Thanks,
Robin
