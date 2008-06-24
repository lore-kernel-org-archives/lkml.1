Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbYFXH7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbYFXH7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 03:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbYFXH7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 03:59:35 -0400
Received: from aun.it.uu.se ([130.238.12.36]:47089 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbYFXH7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 03:59:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18528.43356.997214.585578@harpo.it.uu.se>
Date: Tue, 24 Jun 2008 09:59:24 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Eric Smith" <eric@brouhaha.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Any lightweight way for one thread to force another thread to  
     suspend execution?
In-Reply-To: <57001.64.62.206.10.1214255297.squirrel@ruckus.brouhaha.com>
References: <40921.64.62.206.10.1214006079.squirrel@ruckus.brouhaha.com>
	<877iciyjcs.fsf@basil.nowhere.org>
	<57001.64.62.206.10.1214255297.squirrel@ruckus.brouhaha.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Smith writes:
 > Andi wrote about my inquire regarding a way to synchronously stop
 > another thread:
 > > Any such mechanism will need a syscall, and it's unlikely that
 > > any syscall will get much cheaper than a kill(SIGSTOP)
 > 
 > Unfortunately, as Bart pointed out, this stops ALL the threads
 > in a process (required for POSIX conformance).  However, it appears that
 > I may be able to do it by creating my threads using clone() with appropriate
 > parameters rather than pthread_create().
 > 
 > The next question, which I haven't yet been able to answer for myself
 > from staring at the kernel sources, is whether sending SIGSTOP is
 > synchronous.  In other words, when the kill() returns, is the target
 > thread already stopped?  Even on an SMP system where the thread may have
 > been executing concurrently on another processor?
 > 
 > If not, the next question will be whether there's a more efficient way
 > to wait for a process to enter the "T" state than busy-polling a file
 > in /proc.

SIGSTOP is unreliable since some other process may wake the
target up with a SIGCONT.

man ptrace(), see the PTRACE_ATTACH request.

(Presumably it will DTRT if you give it a tid not just a pid,
but I haven't tested that.)
