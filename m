Return-Path: <linux-kernel-owner+w=401wt.eu-S970555AbXEHXt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970555AbXEHXt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967429AbXEHXts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:49:48 -0400
Received: from ozlabs.org ([203.10.76.45]:54647 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967427AbXEHXtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:49:47 -0400
Subject: Re: [patch 3/4] split usermodehelper setup from execution
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       David Howells <dhowells@redhat.com>,
       Bj?rn Steinbrink <B.Steinbrink@gmx.de>
In-Reply-To: <20070508205517.256147592@goop.org>
References: <20070508205129.064843364@goop.org>
	 <20070508205517.256147592@goop.org>
Content-Type: text/plain
Date: Wed, 09 May 2007 09:49:31 +1000
Message-Id: <1178668171.7286.55.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 13:51 -0700, Jeremy Fitzhardinge wrote:
> plain text document attachment (usermodehelper-split-init.patch)
> Rather than having hundreds of variations of call_usermodehelper for
> various pieces of usermode state which could be set up, split the
> info allocation and initialization from the actual process execution.

Erk, I hadn't realized how extended call_usermodehelper had become.

call_usermodehelper_pipe()?  Erk.  Grepping... for core dumping via a
process?  Without modifying the ELF core dumper (at least) to handle
short writes?  Why not dump it in an agreed location and exec the
process with that as an arg?

When did this go in?  2.6.19... hmm, too late to rip it out I guess 8(

Anyway, I'm not sure exposing an open-ended interface wins: refactoring
internally definitely makes sense though.

Rusty.

