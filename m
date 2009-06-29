Return-Path: <linux-kernel-owner+w=401wt.eu-S1759372AbZF2ON2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759372AbZF2ON2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 10:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbZF2ONV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 10:13:21 -0400
Received: from mtoichi11.ns.itscom.net ([219.110.2.181]:47490 "EHLO
	mtoichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbZF2ONV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 10:13:21 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [PATCH] integrity: add ima_counts_put (updated) 
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <1246039527.4809.18.camel@dyn9002018117.watson.ibm.com>
References: <1246029874-6860-1-git-send-email-zohar@linux.vnet.ibm.com> <1246039527.4809.18.camel@dyn9002018117.watson.ibm.com>
Date: Mon, 29 Jun 2009 23:12:29 +0900
Message-ID: <12000.1246284749@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mimi Zohar:
> This patch fixes an imbalance message as reported by J.R. Okajima.
> The IMA file counters are incremented in ima_path_check. If the
> actual open fails, such as ETXTBSY, decrement the counters to
> prevent unnecessary imbalance messages.

Although I have no objection for this fix, I'd like to suggest you to
stop incrementing the counters in ima_path_check().
A while ago IMA_COUNT_LEAVE and ima_counts_get() were introduced, and
now ima_counts_put() appears.
Isn't it easier something like this,
- stop incrementing in ima_path_check().
- call ima_counts_get() in dentry_open() (or similar).
- delete IMA_COUNT_LEAVE/UPDATE and ima_counts_put().

How do you think?


J. R. Okajima
