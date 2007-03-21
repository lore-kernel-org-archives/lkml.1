Return-Path: <linux-kernel-owner+w=401wt.eu-S1750844AbXCUIox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750844AbXCUIox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 04:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbXCUIox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 04:44:53 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:39469 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbXCUIow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 04:44:52 -0400
From: Nikita Danilov <nikita@clusterfs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17920.61568.770999.626623@gargle.gargle.HOWL>
Date: Wed, 21 Mar 2007 11:44:48 +0300
To: Rik van Riel <riel@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] split file and anonymous page queues #3
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.mm
In-Reply-To: <46005B4A.6050307@redhat.com>
References: <46005B4A.6050307@redhat.com>
X-Mailer: VM 7.17 under 21.5 (patch 17) "chayote" (+CVS-20040321) XEmacs Lucid
X-SystemSpamProbe: GOOD 0.0000500 150bfdc75b699c394f1fbe28887fa8ad
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel writes:
 > [ OK, I suck.  I edited yesterday's email with the new info, but forgot
 >    to change the attachment to today's patch.  Here is today's patch. ]
 > 
 > Split the anonymous and file backed pages out onto their own pageout
 > queues.  This we do not unnecessarily churn through lots of anonymous
 > pages when we do not want to swap them out anyway.

Won't this re-introduce problems similar to ones due to split
inactive_clean/inactive_dirty queues we had in the past?

For example, by rotating anon queues faster than file queues, kernel
would end up reclaiming anon pages that are hotter (in "absolute" LRU
order) than some file pages.

Nikita.

