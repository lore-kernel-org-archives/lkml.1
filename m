Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbXJVMnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbXJVMnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 08:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755066AbXJVMna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 08:43:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44880 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbXJVMn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 08:43:29 -0400
Date: Mon, 22 Oct 2007 13:43:22 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Nix <nix@esperi.org.uk>,
       Jeff Dike <jdike@addtoit.com>, Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
       Ingo Molar <mingo@elte.hu>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in 2.6.23-final.
Message-ID: <20071022124322.GB8181@ftp.linux.org.uk>
References: <20071021154346.GW8181@ftp.linux.org.uk> <20071022043746.GF2998@hacking> <20071022052214.GY8181@ftp.linux.org.uk> <20071022061245.GG2998@hacking> <87d4v7fy5i.fsf@hades.wkstn.nix> <20071022065202.GI2998@hacking> <20071022065943.GC10864@uranus.ravnborg.org> <20071022074823.GJ2998@hacking> <20071022113600.GA8181@ftp.linux.org.uk> <20071022122504.GL2998@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022122504.GL2998@hacking>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 08:25:04PM +0800, WANG Cong wrote:
> >Now apply the patch upthread, it should've fixed that one (and yes, you
> >are down to the stuff this patch is supposed to fix - and does so here).
> 
> Yes, this one is fixed. Thanks for your patch.
> 
> But another one comes out. ;(

Jeff had posted a fix for that one a while ago:

-int __sched wait_for_completion_interruptible(struct completion *x)
+int __sched fastcall wait_for_completion_interruptible(struct completion *x)

in kernel/sched.c

FWIW, I would simply kill the damn fastcall thing - right now the only
user is uml/i386; everything else either has it #defined to nothing or
(as i386 does) passes -mregparm=3 while having fastcall expand to
__attribute__((regparm(3))) - i.e. has all functions fastcall.

Do we really need it on uml/i386 enough to keep bothering with that mess?
