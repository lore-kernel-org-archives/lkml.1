Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbYKFQsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbYKFQsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 11:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbYKFQsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 11:48:14 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47155 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbYKFQsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 11:48:11 -0500
Message-ID: <49131FB3.4060807@redhat.com>
Date: Thu, 06 Nov 2008 11:47:47 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       Hirokazu Takahashi <taka@valinux.co.jp>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Andrea Righi <righi.andrea@gmail.com>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       menage@google.com, ngupta@google.com, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
References: <20081106153022.215696930@redhat.com>	 <1225986593.7803.4688.camel@twins>  <20081106160154.GA7461@redhat.com> <1225988173.7803.4723.camel@twins>
In-Reply-To: <1225988173.7803.4723.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:

> Nice, although I would think only doing the higher level devices makes
> more sense than only doing the leafs.

I'm not convinced.

Say that you have two resource groups on a bunch of LVM
volumes across two disks.

If one of the resource groups only sends requests to one
of the disks, the other resource group should be able to
get all of its requests through immediateley at the other
disk.

Holding up the second resource group's requests could
result in a disk being idle. Worse, once that cgroup's
requests finally make it through, the other cgroup might
also want to use the disk and they both get slowed down.

When a resource is uncontended, should a potential user
be made to wait?

-- 
All rights reversed.
