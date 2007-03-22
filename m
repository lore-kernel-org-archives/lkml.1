Return-Path: <linux-kernel-owner+w=401wt.eu-S965861AbXCVIpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965861AbXCVIpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 04:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965869AbXCVIpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 04:45:46 -0400
Received: from smtp.osdl.org ([65.172.181.24]:44954 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965861AbXCVIpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 04:45:45 -0400
Date: Thu, 22 Mar 2007 00:45:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes-kernel@saeurebad.de>
Cc: roland <devzero@web.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - fix compile warning: `found' might be used
 uninitialized in this function
Message-Id: <20070322004540.45d8ee87.akpm@linux-foundation.org>
In-Reply-To: <20070321235607.GA10998@localhost>
References: <04bf01c76c13$5f25ce00$eeeea8c0@aldipc>
	<20070321235607.GA10998@localhost>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007 00:56:08 +0100 Johannes Weiner <hannes-kernel@saeurebad.de> wrote:

> On Thu, Mar 22, 2007 at 12:48:05AM +0100, roland wrote:
> > fs/block_dev.c: In function `bd_claim_by_kobject':
> > fs/block_dev.c:953: warning: `found' might be used uninitialized in this 
> > function
> 
> found actually _is_ used uninitialized if the call to bd_claim() returns
> anything but 0.

No, it isn't.

        if (res || found)
                free_bd_holder(bo);

`found' won't be evaluated if res!=0.

The code in there is irksome - it'd be nice to find some way of
restructuring it to make it less obscure, and to kill that warning.
