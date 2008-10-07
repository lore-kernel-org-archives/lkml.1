Return-Path: <linux-kernel-owner+w=401wt.eu-S1757627AbYJGVK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbYJGVK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757418AbYJGVJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:09:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55367 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411AbYJGVJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:09:33 -0400
Message-ID: <48EBCFF8.6050500@zytor.com>
Date: Tue, 07 Oct 2008 14:09:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Add clflush before monitor for Intel 7400 series
References: <20081007210056.GA5802@linux-os.sc.intel.com>
In-Reply-To: <20081007210056.GA5802@linux-os.sc.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venki Pallipadi wrote:
> For Intel 7400 series CPUs, the recommendation is to use a clflush on the
> monitored address just before monitor and mwait pair [1]. This clflush makes
> sure that there are no false wakeups from mwait when the monitored address
> was recently written to.
> 
> [1] "MONITOR/MWAIT Recommendations for Intel Xeon Processor 7400 series"
> section in specification update document of 7400 series
> http://download.intel.com/design/xeon/specupdt/32033601.pdf
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

This seems very expensive.  It really makes me wonder if it wouldn't 
just be better to either declare monitor/mwait non-functional on this 
chip, or make sure that mwaits can handle false wakeups.

	-hpa
