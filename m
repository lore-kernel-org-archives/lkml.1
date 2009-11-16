Return-Path: <linux-kernel-owner+w=401wt.eu-S1752615AbZKPLBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbZKPLBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 06:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbZKPLBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 06:01:41 -0500
Received: from cantor.suse.de ([195.135.220.2]:55037 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbZKPLBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 06:01:41 -0500
Message-ID: <4B01310D.3020609@suse.de>
Date: Mon, 16 Nov 2009 20:01:33 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: GPF in run_workqueue()/list_del_init(cwq->worklist.next) on	resume
References: <200911091250.31626.rjw@sisk.pl> <200911092145.27485.rjw@sisk.pl> <alpine.LFD.2.01.0911091339290.31845@localhost.localdomain> <200911100119.38019.rjw@sisk.pl> <alpine.LFD.2.01.0911101343590.31845@localhost.localdomain> <4AFA70FB.60706@kernel.org> <20091111181349.GA30638@redhat.com> <4AFB9595.1030002@kernel.org> <20091112183508.GA14661@redhat.com> <4AFC5E96.1020609@kernel.org>
In-Reply-To: <4AFC5E96.1020609@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

11/13/2009 04:14 AM, Tejun Heo wrote:
>>> making flush_work() behave as
>>> flush_work_sync() by default should be doable without too much
>>> overhead.  I'll give it a shot.

Aieee... my estimate for cross cpu work queueing was way off.
Queueing on different cpus is very common - sometimes more so than on
the same cpu, so it looks like this can't be done without adding
significant overhead to queueing path.  Giving up.  :-(

Thanks.

-- 
tejun
