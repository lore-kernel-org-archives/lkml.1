Return-Path: <linux-kernel-owner+w=401wt.eu-S1751705AbZG2FN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbZG2FN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 01:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbZG2FN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 01:13:26 -0400
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:54804 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbZG2FN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 01:13:26 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [PATCH] integrity: add ima_counts_put (updated) 
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <1246039527.4809.18.camel@dyn9002018117.watson.ibm.com>
References: <1246029874-6860-1-git-send-email-zohar@linux.vnet.ibm.com> <1246039527.4809.18.camel@dyn9002018117.watson.ibm.com>
Date: Wed, 29 Jul 2009 14:12:17 +0900
Message-ID: <8045.1248844337@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mimi Zohar:
> This patch fixes an imbalance message as reported by J.R. Okajima.
> The IMA file counters are incremented in ima_path_check. If the
> actual open fails, such as ETXTBSY, decrement the counters to
> prevent unnecessary imbalance messages.

Unfortunately IMA seems to be still buggy.
may_open() calls ima_path_check() with IMA_COUNT_UPDATE, but may_open()
may fail later with several reasons such like, open-flag mismatch with
inode-flag, capability, the file was executing and get_write_access()
failed, etc.
In these cases, IMA has to maintain its counters too by calling
ima_counts_put() or something, does it?


J. R. Okajima
