Return-Path: <linux-kernel-owner+w=401wt.eu-S1758046AbYEDWTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbYEDWTs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 18:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755591AbYEDWTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 18:19:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55811 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbYEDWTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 18:19:37 -0400
Message-ID: <481E3433.2030408@zytor.com>
Date: Sun, 04 May 2008 15:09:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: monstr@seznam.cz
CC: Arnd Bergmann <arnd@arndb.de>, microblaze-uclinux@itee.uq.edu.au,
       Matthew Wilcox <matthew@wil.cx>, Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       John Williams <john.williams@petalogix.com>,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Linn <John.Linn@xilinx.com>
Subject: Re: microblaze syscall list
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <4813DF3E.6080800@itee.uq.edu.au> <4814A153.3040600@seznam.cz> <200805032357.41043.arnd@arndb.de> <481D7DF7.3000909@seznam.cz>
In-Reply-To: <481D7DF7.3000909@seznam.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Simek wrote:
> /* fs/select.c */
> 	.long sys_select /* obsolete -> sys_pselect6 */
> ok	.long sys_pselect7
> 	.long sys_pselect6 /* obsolete -> sys_pselect7 */

I thought there was some semantic differences between select() and 
pselect()... perhaps those changes have been removed?

> 
> /* kernel/sys_ni.c */
> 	.long sys_ni_syscall /*  :-)  */
> 

There is a school of thought that it's useful to reserve a system call 
number (usually zero) as a system call that is *guaranteed* to have no 
effect.

> /* arch - microblaze specific */
> /* arch/microblaze/kernel/signal.c */
> 	.long sys_sigreturn /* obsolete -> sys_rt_sigreturn */
> ok	.long sys_rt_sigreturn_wrapper /*.long sys_rt_sigreturn*/
> 	.long sys_sigaction /* obsolete -> rt_sigaction */
> 	.long sys_sigsuspend /* obsolete -> rt_sigsuspend */

Btw, please implement rt_sigreturn sanely; on x86, for example, one has 
to pop a word off the stack before one can invoke the system call, when 
used as sa_restorer...

	-hpa

