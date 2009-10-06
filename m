Return-Path: <linux-kernel-owner+w=401wt.eu-S1757748AbZJFSCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748AbZJFSCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755909AbZJFSCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:02:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814AbZJFSCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:02:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] signals: send_signal: use si_fromuser() to detect
	from_ancestor_ns
In-Reply-To: Oleg Nesterov's message of  Tuesday, 6 October 2009 15:18:21 +0200 <20091006131821.GA8628@redhat.com>
References: <20091003171029.GA30442@us.ibm.com>
	<20091004021844.GA21006@redhat.com>
	<20091004021954.GC21006@redhat.com>
	<20091005181255.GE30442@us.ibm.com>
	<20091005182536.GA943@redhat.com>
	<20091005193738.GF30442@us.ibm.com>
	<20091005194415.GA4560@redhat.com>
	<20091006000631.GA4390@us.ibm.com>
	<20091006010956.GA28233@redhat.com>
	<20091006023401.GA10132@us.ibm.com>
	<20091006131821.GA8628@redhat.com>
X-Zippy-Says: An Italian is COMBING his hair in suburban DES MOINES!
Message-Id: <20091006180104.A433822@magilla.sf.frob.com>
Date: Tue,  6 Oct 2009 11:01:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes sure, init can't kill itself with or without these changes. But,
> I think this is supposed behaviour which we do not want to change?

I agree.  (Actually, I think init shouldn't be "protected" that way at all.
You shoot downwards, you get your foot.  But we are not talking about
changing the global init behavior, and I do think that the container-init
behavior should be as consistent as possible with what global init sees.)

It's possible to meaningfully swallow a kill() signal because then nothing
happens at all.  The exec failure cases are special because all the damage
is already done so there is no way to avoid dying, and SIGKILL is just
making it more formal and graceful.


Thanks,
Roland
