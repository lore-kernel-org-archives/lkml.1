Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbZK1LK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbZK1LK0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 06:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbZK1LKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 06:10:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51303 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbZK1LKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 06:10:25 -0500
Date: Sat, 28 Nov 2009 08:28:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org, oleg@redhat.com,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v3 00/27] writable limits
Message-ID: <20091128072839.GA6689@elte.hu>
References: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
 <4B1063A7.2030206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1063A7.2030206@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Slaby <jirislaby@gmail.com> wrote:

> Hi,
> 
> I broke the threading to not mess up with the long thread.
> 
> In this version I got rid of the rlim access_only ugliness.

Thanks Jiri - this series looks very clean already and the helpers make 
the various usage sites easier to understand as well.

One (very small) naming suggestion, please rename:

 rlim_get_cur()
 rlim_get_max()
 task_rlim_get_cur()
 task_rlim_get_max()

To a more natural sounding scheme like:

 rlimit()
 rlimit_max()
 task_rlimit()
 task_rlimit_max()

Reasons:

 - 'cur' is a misnomer that came a decade+ ago from an ABI and there's 
   no need to continue that bad tradition in helper functions. It can 
   also be confused with 'curr' which we often use for the current task.

 - 'rlimit' is general meme, plus there's no need to say it out aloud 
   that we 'get' it - rlimit() is obvious enough.

Beyond solving these issues it makes it shorter and more logical as 
well.

Thanks,

	Ingo
