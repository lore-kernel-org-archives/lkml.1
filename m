Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbYK1HzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbYK1HzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 02:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbYK1HzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 02:55:08 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60316 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbYK1HzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 02:55:07 -0500
Subject: Re: 2.6.28-rc6-git1 -- BUG: unable to handle kernel paging request
	at ffff8800be8b0019
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Hugh Dickins <hugh@veritas.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Miles Lane <miles.lane@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <htejun@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <Pine.LNX.4.64.0811271643250.9618@blonde.site>
References: <a44ae5cd0811250850g725a5a5nd7d93a23ffd2fce6@mail.gmail.com>
	 <200811270026.37941.rjw@sisk.pl>
	 <84144f020811270537l3798b2f5ka63caacbee43b075@mail.gmail.com>
	 <Pine.LNX.4.64.0811271349040.21910@blonde.site>
	 <84144f020811270613t3f0258ddxac52abb9a447bf40@mail.gmail.com>
	 <Pine.LNX.4.64.0811271643250.9618@blonde.site>
Date: Fri, 28 Nov 2008 09:56:50 +0200
Message-Id: <1227859011.6039.2.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-27 at 17:34 +0000, Hugh Dickins wrote:
> An alternative quick just-for-now fix might be to remove that
> 	namebuf[KSYM_NAME_LEN - 1] = 0;
> from kallsyms_lookup(): as I understand it (please check), that
> could only make sense in cases where the symbol is KSYM_NAME_LEN
> long or longer - in which case, all of the places fixed in the
> patch below would be causing corruption already, even without my
> patch.  I think.  Maybe that "= 0" even serves no purpose at all?

I looked into this and unfortunately that won't help us. For example,
module_address_lookup() will copy KSYM_NAME_LEN - 1 bytes to namebuf
anyway so we'll overflow the buffer.

It would probably be a good idea to add a comment to kallsyms_lookup()
stating that namebuf needs to have at least KSYM_NAME_LEN bytes
available.

		Pekka

