Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbYFEH1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbYFEH1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 03:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYFEH1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 03:27:37 -0400
Received: from sous-sol.org ([216.99.217.87]:52366 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbYFEH1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 03:27:36 -0400
Date: Thu, 5 Jun 2008 00:27:28 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@qumranet.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: kvm: unable to handle kernel NULL pointer dereference
Message-ID: <20080605072728.GF30402@sequoia.sous-sol.org>
References: <20080601084802.GA3146@yamamaya.is-a-geek.org> <4846716E.5000506@qumranet.com> <20080604181019.GB10897@yamamaya.is-a-geek.org> <20080605042535.GC30402@sequoia.sous-sol.org> <20080605060931.GA11704@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080605060931.GA11704@yamamaya.is-a-geek.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tobias Diedrich (ranma+kernel@tdiedrich.de) wrote:
> Almost:
> ranma@melchior:~/src/linux-2.6.26-rc4.forcedwol$ gdb -q vmlinux
> Using host libthread_db library "/lib/libthread_db.so.1".
> (gdb)  p/x 0xffffffff8021d456 + 0x6f9cba
> $1 = 0xffffffff80917110
> (gdb) p/x &per_cpu__svm_data
> $2 = 0xffffffff809170f8
> (gdb) 

Sorry, my math was bad.  I gave you 0xffffffff8021d44f + 7 + 0x6f9cba,
but it should have been 0xffffffff8021d44f - 17 + 0x6f9cba.  Which is
correct (as one would hope, it was a grasp at straws).

Oh, wait.  Is this a laptop?  Do you suspend/resume?  Suspend will free
svm_data, and on resume, any launching a guest will definitely hit the
oops you are seeing.

Do you ever see this in dmesg?

  svm_cpu_init: svm_data is NULL on 0

thanks,
chris
