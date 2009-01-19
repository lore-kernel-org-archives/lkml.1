Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbZASS0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbZASS0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 13:26:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbZASS0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 13:26:42 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:46376 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbZASS0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 13:26:41 -0500
Date: Mon, 19 Jan 2009 19:28:25 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kmemtrace: kbuild failed to make the new header symlink...
Message-ID: <20090119182825.GA11165@uranus.ravnborg.org>
References: <20090119164029.GB19302@ghostprotocols.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090119164029.GB19302@ghostprotocols.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 02:40:29PM -0200, Arnaldo Carvalho de Melo wrote:
> Sam,
> 
> 	I just did a git pull on linux-2.6-tip, then, on a build
> directory (make O=../build/blkftrace/) with a previous build a tree
> cloned from Linus I got stuck with the messages below.
> 
> 	I could only get this to work after a make mrproper, thought I
> could mention this so that perhaps this can get detected and time be
> saved somehow.
> 
>   CC      arch/x86/mm/fault.o
> /home/acme_unencrypted/git/linux-2.6-tip/arch/x86/mm/fault.c:38:27: error: asm/kmemcheck.h: No such file or directory
> /home/acme_unencrypted/git/linux-2.6-tip/arch/x86/mm/fault.c: In function ‘do_page_fault’:
> /home/acme_unencrypted/git/linux-2.6-tip/arch/x86/mm/fault.c:614: error: implicit declaration of function ‘kmemcheck_active’
> /home/acme_unencrypted/git/linux-2.6-tip/arch/x86/mm/fault.c:615: error: implicit declaration of function ‘kmemcheck_hide’
> /home/acme_unencrypted/git/linux-2.6-tip/arch/x86/mm/fault.c:644: error: implicit declaration of function ‘kmemcheck_fault’
> 

The problem is that kmemcheck.h is located in include/asm-x86/ which is wrong.
[Checked master branch at mingo/linux-2.6-x86.git of now.
It should be located in arch/x86/include/asm

I think you see the bug due to a wrong symlink being created.

Anyway that symlink will soon be history - at least when we
have a few more archs that has moved to use arch/$ARCH/include

	Sam
