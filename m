Return-Path: <linux-kernel-owner+w=401wt.eu-S1161175AbXDWSCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161175AbXDWSCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 14:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161205AbXDWSCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 14:02:43 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52354 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161175AbXDWSCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 14:02:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Chuck Ebbert <cebbert@redhat.com>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 10/28] i386: map enough initial memory to create lowmem mappings
References: <20070414204154.871250608@goop.org>
	<200704192250.52633.ak@suse.de> <4627D756.5020405@zytor.com>
	<200704192304.01053.ak@suse.de> <4627DB0C.2010804@zytor.com>
	<4627DDAD.4070805@redhat.com> <4627E099.209@goop.org>
	<m1d51vxxm4.fsf@ebiederm.dsl.xmission.com> <462CE027.4030302@goop.org>
	<462CE1E0.9060007@zytor.com> <462CE69E.8040207@goop.org>
	<462CEB55.9070508@zytor.com>
Date: Mon, 23 Apr 2007 12:00:51 -0600
In-Reply-To: <462CEB55.9070508@zytor.com> (H. Peter Anvin's message of "Mon,
	23 Apr 2007 10:22:29 -0700")
Message-ID: <m17is3vulo.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Agreed.  However, saying that your patch shouldn't go into the mainline kernel
> until that has been fixed is spurious and wrong.  It fixes a real problem with
> minimal risk.

For a stable and frozen kernel it is probably the best we can do.

However the code is based on confusion of what should be happening and
it increases the complexity of the code and pushes us towards the edge of
code that is so crufty it is impossible to maintain.

We need to simplify this mess not make it more convoluted.

Did anyone else notice that if we don't have PAE we continue to use
the initial page tables 4K page mappings of the kernel?

This probably explains why experiments to 4MB align the i386 kernel
to improve performance failed.

Eric
