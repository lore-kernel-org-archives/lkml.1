Return-Path: <linux-kernel-owner+w=401wt.eu-S1761663AbZJMXzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761663AbZJMXzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 19:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761642AbZJMXzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 19:55:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761639AbZJMXzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 19:55:07 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       peterz@infradead.org, Louis.Rilling@kerlabs.com,
       kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com,
       linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
In-Reply-To: Sukadev Bhattiprolu's message of  Tuesday, 13 October 2009 16:27:36 -0700 <20091013232736.GA24392@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com>
	<20091013205015.1ED524F7@magilla.sf.frob.com>
	<20091013232736.GA24392@us.ibm.com>
X-Shopping-List: (1) Malignant citations
   (2) Arduous obnoxious watch honkers
   (3) Magisterial chains
   (4) Excellent shrubbery
   (5) Obvious sand harmonizers
Message-Id: <20091013235320.E90022746@magilla.sf.frob.com>
Date: Tue, 13 Oct 2009 16:53:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My only concern is the support of 64-bit clone flags on 32-bit architectures.

Oy.  I didn't realize there was serious consideration of having more than
32 flags.  IMHO it would be a bad choice, since they could only be used via
clone3.  Having high-bit flags work in clone on 64-bit machines but not on
32-bit machines just seems like a wrongly confusing way for things to be.
If any high-bits flags are constrained even on 64-bit machines to uses in
clone3 calls for sanity purposes, then it seems questionable IMHO to have
them be more flags in the same u64 at all.

Since all new features will be via this struct, various new kinds of things
could potentially be done by other new struct fields independent of flags.
But that would of course require putting enough reserved fields in now and
requiring that they be zero-filled now in anticipation of such future uses,
which is not very pleasant either.

In short, I guess I really am saying that "clone_flags_high" (or
"more_flags" or something) does seem better to me than any of the
possibilities for having more than 32 CLONE_* in the current flags word.


Thanks,
Roland
