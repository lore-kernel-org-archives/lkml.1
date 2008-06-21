Return-Path: <linux-kernel-owner+w=401wt.eu-S1752657AbYFUQEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbYFUQEB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 12:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbYFUQDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 12:03:52 -0400
Received: from smtp-out.google.com ([216.239.33.17]:58838 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbYFUQDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 12:03:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=qSxclRHnrQtg0Ktfxt/CWWp6F9lpXze2Sw8mkKFBHdJqeL7zvRthP8Rf+hwplZ/vH
	ixiTjhOORYyV4zcZ9EVoQ==
Message-ID: <6599ad830806210903p396bb856q16143f5f28a9f6f2@mail.gmail.com>
Date: Sat, 21 Jun 2008 09:03:44 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [PATCH] Priority heap infrastructure enhancements
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <485CB652.90801@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213796886-24863-1-git-send-email-balbir@linux.vnet.ibm.com>
	 <6599ad830806210029x2a020e1ava6b646be9913fcdf@mail.gmail.com>
	 <485CB652.90801@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2008 at 1:05 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
> I would like to be able to drop the smallest value. Since we cannot drop the
> smallest value, dropping a leaf (heap->size) should be sufficiently good enough.
> I want a max heap and losing the root of the heap does not work for me.

Dropping the last element will give you an "approximate-max" heap -
once you've finished building the heap, for a heap depth of N I think
the first N-1 calls to heap_delete_max() will give correct results,
but any time after that you could be missing things that were dropped
incorrectly during the building phase.

If this is OK for what you're trying to do, then either:

- adding a adding a heap_insert_drop_leaf_on_overflow() function, or

- adding a flag to the heap structure indicating what to do on overflow

sounds fine.

Paul
