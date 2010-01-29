Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053Ab0A2Wym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab0A2Wym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 17:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943Ab0A2Wyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 17:54:41 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:63287 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab0A2Wyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 17:54:40 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAIr2YkurR7H+/2dsb2JhbADDGpdOhEIE
X-IronPort-AV: E=Sophos;i="4.49,371,1262563200"; 
   d="scan'208";a="475123963"
From: Roland Dreier <rdreier@cisco.com>
To: Alex Chiang <achiang@hp.com>
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Increase maximum Infiniband HCAs per-system
References: <20100129214039.17745.38679.stgit@bob.kio>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 29 Jan 2010 14:54:36 -0800
In-Reply-To: <20100129214039.17745.38679.stgit@bob.kio> (Alex Chiang's message
	of "Fri, 29 Jan 2010 14:44:57 -0700")
Message-ID: <adar5p8ldxv.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Justin Chen discovered that Linux "only" supports 32 IB cards in
 > a single system when testing a larger system with 40 cards and
 > discovered that OFED only reported 32 HCAs.
 > 
 > This patchset doubles the number of HCAs allowed per system in a
 > backwards-compatible manner.

Looks like a really great start, some nice cleanups as well the added
functionality.  I've been meaning to use pahole for a while...

Have you considered drivers/infiniband/core/user_mad.c and ucm.c?  I
think user_mad.c is somewhat more important, as that is what allows an
adapter to be used for running the SM.  So I think we're still left with
some potential issues around lots of adapters in one system.  (I think
use of ucm by real apps is minimal to nonexistent, but someday we should
deal with that too)

 - R.
