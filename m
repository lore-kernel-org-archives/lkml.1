Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbYILDwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbYILDwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 23:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbYILDv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 23:51:57 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:34787 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbYILDv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 23:51:57 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [PATCH] netlink: fix overrun in attribute iteration
Date: Fri, 12 Sep 2008 03:51:54 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <gacp0q$drj$1@taverner.cs.berkeley.edu>
References: <20080911205933.GA20032@localhost.localdomain>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1221191514 14195 128.32.168.222 (12 Sep 2008 03:51:54 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Fri, 12 Sep 2008 03:51:54 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum  wrote:
>  /**
>   * nla_ok - check if the netlink attribute fits into the remaining bytes
>   * @nla: netlink attribute
>   * @remaining: number of bytes remaining in attribute stream
>   */
>  static inline int nla_ok(const struct nlattr *nla, int remaining)
>  {
>          return remaining >= sizeof(*nla) &&
>                 nla->nla_len >= sizeof(*nla) &&
>                 nla->nla_len <= remaining;
>  }

If 'remaining' had been declared to be of type size_t, this would
not have happened.

Guideline for secure programming: length values (and counts of bytes)
should be declared as size_t, where possible.

This guideline eliminates many signed/unsigned bugs.  If one also
carefully avoids overflow (wraparound), other integer overflow bugs
are avoided as well.

The code above violates the guideline so we shouldn't be terribly
surprised if it happens to contain signed/unsigned vulnerabilities.
