Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894AbYGPGXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbYGPGXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 02:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYGPGXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 02:23:31 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49834 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbYGPGX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 02:23:29 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5339"; a="4754001"
Message-ID: <487D93CD.1000007@qualcomm.com>
Date: Tue, 15 Jul 2008 23:23:09 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       virtualization@lists.linux-foundation.org,
       Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH] stopmachine: add stopmachine_timeout v2
References: <487B05CE.1050508@jp.fujitsu.com> <487D78A3.6050105@jp.fujitsu.com>
In-Reply-To: <487D78A3.6050105@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hidetoshi Seto wrote:
> Thank you for useful feedbacks!
> Here is the updated version.
> Could you put this on top of your patches, Rusty?
> 
> Thanks,
> H.Seto
> 
> 
> If stop_machine() invoked while one of onlined cpu is locked up
> by some reason, stop_machine cannot finish its work because the
> locked cpu cannot stop.  This means all other healthy cpus
> will be blocked infinitely by one dead cpu.
> 
> This patch allows stop_machine to return -EBUSY with some printk
> messages if any of stop_machine's threads cannot start running on
> its target cpu.
> 
> v2:
>  - remove fix for warning since it will be fixed upcoming typesafe
>    patches
>  - make stopmachine_timeout from secs to msecs, and set default to
>    200 msec (since v1's arbitrary 5 sec is too long)
>  - allow disabling timeout by setting the stopmachine_timeout to 0
> 

I'd set the default to zero. I beleive that's what Heiko suggested too.

Max
