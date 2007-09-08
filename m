Return-Path: <linux-kernel-owner+w=401wt.eu-S1752789AbXIHJnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbXIHJnc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 05:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbXIHJnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 05:43:24 -0400
Received: from mx1.Informatik.Uni-Tuebingen.De ([134.2.12.5]:39310 "EHLO
	mx1.informatik.uni-tuebingen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752118AbXIHJnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 05:43:23 -0400
From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>,
       Bernd Schubert <bs@q-leap.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
       brian@clusterfs.com
Subject: Re: patch: improve generic_file_buffered_write() (2nd try 1/2)
References: <200709051546.06224.bs@q-leap.de>
	<87d4wuch8y.fsf@informatik.uni-tuebingen.de>
	<200709081725.06343.nickpiggin@yahoo.com.au>
	<200709081731.51263.nickpiggin@yahoo.com.au>
Date: Sat, 08 Sep 2007 11:43:03 +0200
In-Reply-To: <200709081731.51263.nickpiggin@yahoo.com.au> (Nick Piggin's
	message of "Sat, 8 Sep 2007 17:31:50 +1000")
Message-ID: <874pi5cx20.fsf@informatik.uni-tuebingen.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

> Lustre should probably have to be ported over to write_begin/write_end in
> order to use it too. With the patches in -mm, if a filesystem is still using
> prepare_write/commit_write, the vm reverts to a safe path which avoids
> the deadlock (and allows multi-seg io copies), but copies the data twice.

Not quite relevant for the performance problem. The situation is like
this:

lustre servers  <-lustre network protocol-> lustre client <-NFS-> desktop

The NFSd problem is on the lustre client that only plays gateway. That
is not to say that the lustre servers or desktop loose performance due
to fragmenting writes too but it isn't that noticeable there.

> OTOH, this is very likely to go upstream, so your filesystem will need to be
> ported over sooner or later anyway.

Lustre copies the ext3 source from the kernel, patches in some extra
features and renames them during build. So one the one hand it always
breaks whenever someone meddles with the ext3 code. On the other hand
improvement for ext3 get picked up by lustre semi automatically.

In this case lustre would get the begin_write() function from ext3 and
use it.

MfG
        Goswin

