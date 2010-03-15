Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935697Ab0COHsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 03:48:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933904Ab0COHsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 03:48:24 -0400
Message-ID: <4B9DE635.8030208@redhat.com>
Date: Mon, 15 Mar 2010 09:48:05 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: KVM development list <kvm@vger.kernel.org>,
       Rik van Riel <riel@surriel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RF C/T/D] Unmapped page cache control - via boot parameter
References: <20100315072214.GA18054@balbir.in.ibm.com>
In-Reply-To: <20100315072214.GA18054@balbir.in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2010 09:22 AM, Balbir Singh wrote:
> Selectively control Unmapped Page Cache (nospam version)
>
> From: Balbir Singh<balbir@linux.vnet.ibm.com>
>
> This patch implements unmapped page cache control via preferred
> page cache reclaim. The current patch hooks into kswapd and reclaims
> page cache if the user has requested for unmapped page control.
> This is useful in the following scenario
>
> - In a virtualized environment with cache!=none, we see
>    double caching - (one in the host and one in the guest). As
>    we try to scale guests, cache usage across the system grows.
>    The goal of this patch is to reclaim page cache when Linux is running
>    as a guest and get the host to hold the page cache and manage it.
>    There might be temporary duplication, but in the long run, memory
>    in the guests would be used for mapped pages.
>    

Well, for a guest, host page cache is a lot slower than guest page cache.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

