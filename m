Return-Path: <linux-kernel-owner+w=401wt.eu-S1758993AbYBZDVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758993AbYBZDVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 22:21:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYBZDVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 22:21:00 -0500
Received: from relay2.sgi.com ([192.48.171.30]:56026 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753655AbYBZDVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 22:21:00 -0500
Date: Mon, 25 Feb 2008 21:20:56 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/6] mempolicy: convert MPOL constants to enum
Message-Id: <20080225212056.ca388983.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:

+enum {
+	MPOL_DEFAULT,
+	MPOL_PREFERRED,
+	MPOL_BIND,
+	MPOL_INTERLEAVE,
+	MPOL_MAX,	/* always last member of enum */

Aren't the values that these constants take part of the
user visible kernel API?

In other words, if someone added another MPOL_* in the middle
of this enum, it would break mbind/set_mempolicy/get_mempolicy
users, right:

+enum {
+	MPOL_DEFAULT,
+	MPOL_PREFERRED,
+	MPOL_YET_ANOTHER_FLAG,		/* <== added flag ... oops */
+	MPOL_BIND,
+	MPOL_INTERLEAVE,
+	MPOL_MAX,	/* always last member of enum */

I'm thinking that we should still specify the specific value
of each of these flags, by way of documenting these necessary
values, as in:

+enum {
+	MPOL_DEFAULT = 0,
+	MPOL_PREFERRED = 1,
+	MPOL_BIND = 2,
+	MPOL_INTERLEAVE = 3,
+	MPOL_MAX,	/* always last member of enum */


-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
