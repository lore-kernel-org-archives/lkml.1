Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbYDHLl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbYDHLl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbYDHLlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:41:50 -0400
Received: from os.eurotux.com ([216.75.63.6]:52710 "EHLO os.eurotux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbYDHLlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:41:49 -0400
From: Nuno Fernandes <npf-mlists@eurotux.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: proc_stack for x86_64 (spinning process)
Date: Tue, 8 Apr 2008 12:41:45 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200804081136.41876.npf@eurotux.com> <87myo4pp66.fsf@basil.nowhere.org>
In-Reply-To: <87myo4pp66.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804081241.45776.npf-mlists@eurotux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 April 2008 12:21:53 Andi Kleen wrote:
> Nuno Pais Fernandes <npf@eurotux.com> writes:
> > Hi,
> >
> > I have a spinning process that it's locking my server (eating 100% CPU).
> > I can't kill it even with kill -9
> >
> > I'm trying to use proc_stack to check what's the problem, compiling the
> > kernel with
> >
> > http://linuxhacker.ru/~nikita/patches/2.6.12-rc6/2005.06.11/vm_07-proc-st
> >ack.patch
> >
> > But this patch is only for x86 as my arch is x86_64. Does anyone know if
> > there's a patch for x86_64?
>
> The standard way to handle that is to just do
>
> echo 1 > /proc/sys/kernel/sysrq
> echo t > /proc/sysrq-trigger
>
> and then look for the process backtrace in the kernel log.
I've already done that but the problem is that the "R" script does not show 
any backtrack. Apparently it's spinning inside kernel and all other processes 
become in D state (uninterrutable sleep) because of that one.

Apr  7 15:22:03 app14 kernel: comentarios   R  running task       0  7615   
8051                     (NOTLB)
Apr  7 15:22:03 app14 kernel: comentarios   D ffffff80e2570030     0  8150   
7328                     (NOTLB)
Apr  7 15:22:03 app14 kernel: ffffff80cc8bfcf8 0000000000000282 
00000000f69539c0 ffffff80eea385b0
Apr  7 15:22:03 app14 kernel:        ffffff80e2570030 000000000011d7be 
001769ecf4f60e59 ffffff8000e26030
Apr  7 15:22:03 app14 kernel:        ffffff80e25702c8 0000000000000000
Apr  7 15:22:03 app14 kernel: Call 
Trace:<ffffffffa011d4fd>{:ocfs2:ocfs2_dentry_revalidate+369}
Apr  7 15:22:03 app14 kernel:        <ffffffff8018149e>{do_lookup+419} 
<ffffffff80292e6b>{__down+147}
Apr  7 15:22:03 app14 kernel:        
<ffffffff8012b177>{default_wake_function+0} 
<ffffffff80187f0a>{lease_alloc+96}
Apr  7 15:22:03 app14 kernel:        <ffffffff802945cf>{__down_failed+53} 
<ffffffff801c9faf>{dummy_inode_permission+0}
Apr  7 15:22:03 app14 kernel:        
<ffffffff801c9faf>{dummy_inode_permission+0} 
<ffffffff80174017>{.text.lock.open+5}
Apr  7 15:22:03 app14 kernel:        <ffffffff8018ba2e>{__d_lookup+287} 
<ffffffff80181096>{get_write_access+62}
Apr  7 15:22:03 app14 kernel:        <ffffffff80182fd4>{may_open+481} 
<ffffffff80183340>{open_namei+788}
Apr  7 15:22:03 app14 kernel:        <ffffffff80173c22>{filp_open+80} 
<ffffffff8018a91d>{dput+56}
Apr  7 15:22:03 app14 kernel:        <ffffffff801e8195>{strncpy_from_user+74} 
<ffffffff8011f62c>{sys32_open+54}
Apr  7 15:22:03 app14 kernel:        <ffffffff8011d178>{ia32_sysret+0}

Thanks,
Nuno Fernandes

> Another alternative is to use crash to take a live dump and then analyse
> that using crash.
>
> -Andi


