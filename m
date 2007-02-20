Return-Path: <linux-kernel-owner+w=401wt.eu-S932924AbXBTM4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924AbXBTM4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 07:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932925AbXBTM4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 07:56:36 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55218 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932924AbXBTM4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 07:56:35 -0500
Date: Tue, 20 Feb 2007 06:56:26 -0600
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
Message-ID: <20070220125626.GC27551@lnx-holt.americas.sgi.com>
References: <45DAC32B.4030603@hitachi.com> <45D5B483.3020502@hitachi.com> <45D5B2E3.3030607@hitachi.com> <20368.1171638335@redhat.com> <18826.1171969097@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18826.1171969097@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 10:58:17AM +0000, David Howells wrote:
> Kawai, Hidehiro <hidehiro.kawai.ez@hitachi.com> wrote:
> Actually, I don't think the locking is that hard or that complex.
> 
> 	int do_coredump(long signr, int exit_code, struct pt_regs * regs)
> 	{
> 		<setup vars>
> 
> 		down_read(&coredump_settings_sem);
> 
> 		...
> 
> 	fail:
> 		up_read(&coredump_settings_sem);
> 		return retval;
> 	}
> 
> And:
> 
> 	static ssize_t proc_coredump_omit_anon_shared_write(struct file *file,
> 						    const char __user *buf,
> 						    size_t count,
> 						    loff_t *ppos)
> 	{
> 		<setup vars>
> 
> 		down_write(&coredump_settings_sem);

If the dump has started, do we want to change this to a trylock and skip
changing the value if it is already locked?

Thanks,
Robin
