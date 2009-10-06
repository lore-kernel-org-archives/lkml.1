Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbZJFHcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbZJFHcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 03:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbZJFHcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 03:32:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937AbZJFHcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 03:32:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] signals: SEND_SIG_NOINFO should be considered as
	SI_FROMUSER()
In-Reply-To: Oleg Nesterov's message of  Sunday, 4 October 2009 04:19:18 +0200 <20091004021918.GB21006@redhat.com>
References: <4AC608BE.9020805@fr.ibm.com>
	<20091003171029.GA30442@us.ibm.com>
	<20091004021844.GA21006@redhat.com>
	<20091004021918.GB21006@redhat.com>
X-Zippy-Says: ..  I think I'll KILL myself by leaping out of this 14th STORY
    WINDOW while reading ERICA JONG'S poetry!!
Message-Id: <20091006073100.4184128@magilla.sf.frob.com>
Date: Tue,  6 Oct 2009 00:31:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This whole series looks fine to me.  I think in commenting and cleaning up
any of this, it bears explicit mention that (almost) every signal is
potentially reduced to SI_USER.  That is, in siqueue exhaustion you don't
get any info and only non-special non-SI_USER >=SIGRTMIN signals ever fail
to get posted, so you get the all-zeros defaults from collect_signal() at
delivery time.  That's the principle you're encoding in your si_fromuser()
logic, but your logs and comments are not explicit about the relationship
between that logic and what's implicit in the queue-exhaustion behavior.


Thanks,
Roland
