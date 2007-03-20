Return-Path: <linux-kernel-owner+w=401wt.eu-S934082AbXCTVeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082AbXCTVeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 17:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934081AbXCTVeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 17:34:12 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:30451 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934082AbXCTVeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 17:34:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HZhktzaCEp2nHlaMX6yauIc4Oxja3D2+gi0PqqokOzZul3bvEcZj5E8TBkVOS1bTBkCRZnxz5OpkB1AKul7fXtr1idJyuKsAc386k+S6Dn/lz88hA8MUHNRItvzQMvPV+dBpLkpwLCKdwWl/pzXkJTMV2FH1bQ/iJpnI2vDohGA=
Message-ID: <a8f16e2b0703201434w39108ed0m6d1b50f3b8cd6c42@mail.gmail.com>
Date: Wed, 21 Mar 2007 00:34:08 +0300
From: "Dan Kruchinin" <dubalom@gmail.com>
To: "Chris Friesen" <cfriesen@nortel.com>, linux-kernel@vger.kernel.org
Subject: Re: how to purposfully fragment memory?
In-Reply-To: <4600393C.8030401@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46001D5C.3020406@nortel.com>
	 <a8f16e2b0703201215q78dfdd3du54c77be7c9d843e0@mail.gmail.com>
	 <4600393C.8030401@nortel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/20/07, Chris Friesen <cfriesen@nortel.com> wrote:
> Asgard wrote:
>
> > btw, can you describe your aim in details?
>
> I'm doing some work on a network device driver.  We were having jumbo
> frame issues after being up for a month or so because it couldn't
> allocate enough contiguous memory.
>
> We've got a new code path now that doesn't need large contiguous
> allocations, so I'd like to demonstrate it by forcing the system to
> become severely fragmented.
>
> Chris
>

and by the way, you can try to use void split_page(struct page *page,
unsigned int order) function, but keep in mind, that it's not
recommended to use it in drivers:
/*
 * split_page takes a non-compound higher-order page, and splits it into
 * n (1<<order) sub-pages: page[0..n]
 * Each sub-page must be freed individually.
 *
 * Note: this is probably too low level an operation for use in drivers.
 * Please consult with lkml before using this in your driver.
 */
void split_page(struct page *page, unsigned int order)

Good luck.
Dan.
