Return-Path: <linux-kernel-owner+w=401wt.eu-S1760030AbZIQSxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030AbZIQSxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 14:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759714AbZIQSxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 14:53:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53878 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759310AbZIQSxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 14:53:09 -0400
Date: Thu, 17 Sep 2009 20:53:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: [bug] /etc/profile: line 30: /dev/null: Permission denied (Was:
	Re: [PATCH] Remove broken by design and by implementation devtmpfs
	maintenance disaster)
Message-ID: <20090917185306.GA28635@elte.hu>
References: <m1y6oef08k.fsf@fess.ebiederm.org> <20090917125759.GA4045@kroah.com> <m1ab0tcwep.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ab0tcwep.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Greg this code does not live up to the standards you have repeatedly 
> asserted are required for accepting core kernel code.  Neither you nor 
> Kay show any interest in fixing even the most trivial of bugs. Must 
> less discuss alternate solutions to the problem.

on a tangential note - i have no opinion yet in this discussion, but i 
found no pull request email on lkml and wanted to report a devtmpfs bug:

I've reproduced a bug with the following .config options:

  CONFIG_DEVTMPFS=y
  CONFIG_DEVTMPFS_MOUNT=y

/dev/null and /dev/zero are not read/writable to ordinary users, 
breaking normal bootup and login:

  earth4:~/tip> m
  PTY allocation request failed on channel 0
  /etc/profile: line 30: /dev/null: Permission denied
                                                   
  /etc/profile.d/colorls.sh: line 3: /dev/null: Permission denied
                        /etc/profile.d/colorls.sh: line 4: /dev/null: 
  Permission denied
                                                                                     
  /etc/profile.d/vim.sh: line 5: /dev/null: Permission denied
                                                     Connection to m 
  closed by remote host.
  Connection to m closed.

Regarding the wish to have in-kernel code: another solution which i have 
not seen mentioned would be to move udev into tools/udev/ instead. That 
would give a single, coherent user-space kernel-space combo.

The concept certainly works great for tools/perf/.

The system boots up fine with devtmpfs disabled:

  earth4:~/tip> m
  Last login: Fri Sep 18 02:48:19 2009 from sirius
  mercury:~> 

	Ingo
