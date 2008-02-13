Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbYBMB2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbYBMB2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:28:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbYBMB2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:28:41 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50515 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754342AbYBMB2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:28:39 -0500
Date: Tue, 12 Feb 2008 19:28:36 -0600
From: Paul Jackson <pj@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Lee.Schermerhorn@hp.com, rientjes@google.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] mempolicy: convert MPOL constants to enum
Message-Id: <20080212192836.a8500902.pj@sgi.com>
In-Reply-To: <Pine.LNX.4.64.0802121702431.11628@schroedinger.engr.sgi.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	<1202861432.4974.29.camel@localhost>
	<20080212183158.3ff4ccd5.pj@sgi.com>
	<Pine.LNX.4.64.0802121702431.11628@schroedinger.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph wrote:
> We usually do that with unsigned XXX and constants. You may want to check 
> multiple flags at once or do other fancy things.

Both are common in the kernel.  I see 241 ":1" bit fields in include/linux/*.h.

One can do Boolean expressions with either form, bitfields or defines.

For example:

	struct {
		int foo:1;
		int goo:1;
	} x;

	if (x.foo && ! x.goo)
		blah blah ...;

Doing (x.flags & FLAG_FOO) is simple enough, but it is still
not as simple as (x.foo).  Where possible, I encourage keeping
extraneous detail out of mainline code.

Sometimes, such as in task struct flags, one has to do such Boolean
combinations in performance critical code paths, and then one must do
what one must do, with the defined constants.

Sometimes, such as with the GFP_* flags, one has to name various
combinations, and then one needs again to use defined constants.

I see no evidence that either of those situations applies here.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
