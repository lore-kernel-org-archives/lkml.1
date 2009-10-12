Return-Path: <linux-kernel-owner+w=401wt.eu-S933520AbZJLWfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933520AbZJLWfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933477AbZJLWfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:35:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933486AbZJLWfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:35:00 -0400
Date: Tue, 13 Oct 2009 00:32:59 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>, Mike Frysinger <vapier@gentoo.org>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Roman Zippel <zippel@linux-m68k.org>, Greg Ungerer <gerg@uclinux.org>,
       David Howells <dhowells@redhat.com>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: [PATCH 0/6 RFC] Remove the BKL from sys_execve on various
 architectures
Message-ID: <alpine.LFD.2.00.0910130021440.3658@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the mainstream architectures such as x86, x86-64 and ppc, do not 
use the bkl in sys_execve.

All of the architectures that still use it, look like copy-and-pastes from 
a time when the mainstream architectures did use it. In addition, all of 
the call-outs appear to be to generic functions that are safe to use 
without the bkl. Therefore, I believe it should be safe to simply remove.

However, the bkl does some surprising things, and I could be wrong. So 
please have a look at let us know if there is a reason why your 
architecture does indeed need the bkl in sys_execve.

Even better, grab the relevant patch and do some testing and report back.

Thank you in advance.

John Kacur
