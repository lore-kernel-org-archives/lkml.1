Return-Path: <linux-kernel-owner+w=401wt.eu-S1762098AbXG2MAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762098AbXG2MAF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 08:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757219AbXG2L7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 07:59:54 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35217 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757845AbXG2L7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 07:59:53 -0400
Date: Sun, 29 Jul 2007 04:59:51 -0700
From: Paul Jackson <pj@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       lee.schermerhorn@hp.com, bob.picco@hp.com, clameter@sgi.com
Subject: Re: +
 numa-generic-management-of-nodemasks-for-various-purposes.patch added to
 -mm tree
Message-Id: <20070729045951.55b2285b.pj@sgi.com>
In-Reply-To: <200707290715.l6T7FtN8013215@imap1.linux-foundation.org>
References: <200707290715.l6T7FtN8013215@imap1.linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Schermerhorn (via Andrew) wrote:
> +static inline void node_set_state(int node, enum node_states state)
> +{
> +	__node_set(node, &node_states[state]);
> +}
> +
> +static inline void node_clear_state(int node, enum node_states state)
> +{
> +	__node_clear(node, &node_states[state]);
> +}


Lee - would you get the same result (same compiled binary code) with
something like:

+static inline void node_set_state(int node, enum node_states state)
+{
+	node_set(node, node_states[state]);
+}
+
+static inline void node_clear_state(int node, enum node_states state)
+{
+	node_clear(node, node_states[state]);
+}

If so, then I're prefer the latter, as it doesn't depend on the strange
#define wrapping an inline implementation of node_set and node_clear.

In other words, the latter looks 'simpler'.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
