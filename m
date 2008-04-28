Return-Path: <linux-kernel-owner+w=401wt.eu-S965913AbYD1T4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965913AbYD1T4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765483AbYD1Tzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:55:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932082AbYD1Tzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:55:54 -0400
Date: Mon, 28 Apr 2008 15:55:00 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: lee.schermerhorn@hp.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH -mm 00/15] VM pageout scalability improvements (V6)
Message-ID: <20080428155500.0ab3f4a7@cuia.boston.redhat.com>
In-Reply-To: <20080428181835.502876582@redhat.com>
References: <20080428181835.502876582@redhat.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 14:18:35 -0400
Rik van Riel <riel@redhat.com> wrote:

> This patch series improves VM scalability 

Here is some (absolutely minimal) performance data.

Running "fillmem 16000" on my 16 GB test system puts the system about 800MB
into swap.  Both run time and CPU use are improved with this patch series.
The numbers are an average of about a dozen runs.

2.6.25-mm1:
real	1m31
user	0m11
sys	0m32

2.5.25-mm1-splitvm:
real	1m02
user	0m11
sys	0m22

This does not account for kswapd CPU use, which accumulated to about 56
seconds total in the splitvm kernel, but around 5 minutes on 2.6.25-mm1.

I will make a kernel RPM with the split LRU patch set available so other
people can easily do performance tests.

-- 
All Rights Reversed
