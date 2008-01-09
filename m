Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbYAICEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbYAICEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 21:04:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbYAICEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 21:04:23 -0500
Received: from ozlabs.org ([203.10.76.45]:58217 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbYAICEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 21:04:22 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 5/6] syslets: add generic syslets infrastructure
Date: Wed, 9 Jan 2008 13:03:57 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dan Williams <dan.j.williams@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
       Simon Holm Thogersen <odie@cs.aau.dk>, suresh.b.siddha@intel.com
References: <1196983219534-git-send-email-zach.brown@oracle.com> <1196983219370-git-send-email-zach.brown@oracle.com> <11969832192130-git-send-email-zach.brown@oracle.com>
In-Reply-To: <11969832192130-git-send-email-zach.brown@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801091303.58920.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 December 2007 10:20:18 Zach Brown wrote:
> The indirect syslet arguments specify where to store the completion and
> what function in userspcae to return to once the syslet has been executed. 
> The details of how we pass the indirect syslet arguments needs help.

Hi Zach,

    Firstly, why not just specify an address for the return value and be done 
with it?  This infrastructure seems overkill, and you can always extend later 
if required.

Secondly, you really should allow integration with an eventfd so you don't 
make the posix AIO mistake of providing a poll-incompatible interface.

Finally, and probably most alarmingly, AFAICT randomly changing TID will break 
all threaded programs, which means this won't be fitted into existing code 
bases, making it YA niche Linux-only API 8(

Cheers,
Rusty.
