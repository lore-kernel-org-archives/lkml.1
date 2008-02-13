Return-Path: <linux-kernel-owner+w=401wt.eu-S1765798AbYBMBEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765798AbYBMBEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:04:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbYBMBE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:04:26 -0500
Received: from relay2.sgi.com ([192.48.171.30]:50811 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753066AbYBMBEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:04:25 -0500
Date: Tue, 12 Feb 2008 17:04:24 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Jackson <pj@sgi.com>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, rientjes@google.com,
       akpm@linux-foundation.org, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] mempolicy: convert MPOL constants to enum
In-Reply-To: <20080212183158.3ff4ccd5.pj@sgi.com>
Message-ID: <Pine.LNX.4.64.0802121702431.11628@schroedinger.engr.sgi.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
 <1202861432.4974.29.camel@localhost> <20080212183158.3ff4ccd5.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, Paul Jackson wrote:

> I'm inclined toward the original types for the 'policy' field.

Good. And remove the enum.

> Specifically, I'd suggest adding the one line for 'mode_f_static_nodes'
> as below, and leaving the code involving the encoding of the policy
> field alone.
> 
> struct mempolicy {
>         atomic_t refcnt;
>         short policy;   /* See MPOL_* above */
> 	int mode_f_static_nodes:1;			/* <== Added line <== */

It would be better to add some sort of flags field?

> Single bit fields (The ":1" above) provide the simplest way to add
> boolean flags to structs.  Let the compiler do the work of packing
> and unpacking the field.

We usually do that with unsigned XXX and constants. You may want to check 
multiple flags at once or do other fancy things.

