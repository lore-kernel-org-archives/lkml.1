Return-Path: <linux-kernel-owner+w=401wt.eu-S965268AbXCHV5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965268AbXCHV5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 16:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965259AbXCHV5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 16:57:31 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:31822 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965136AbXCHV52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 16:57:28 -0500
X-IronPort-AV: i="4.14,264,1170662400"; 
   d="scan'208"; a="398915208:sNHT339420444"
To: "David Brown" <dmlb2000@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: KVM and rtc missing interupts 2.6.21-rc3
X-Message-Flag: Warning: May contain useful information
References: <9c21eeae0703081348i713c996bked9ebe2af76bc2db@mail.gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 08 Mar 2007 13:57:21 -0800
In-Reply-To: <9c21eeae0703081348i713c996bked9ebe2af76bc2db@mail.gmail.com> (David Brown's message of "Thu, 8 Mar 2007 13:48:43 -0800")
Message-ID: <adatzwvxuta.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 08 Mar 2007 21:57:21.0439 (UTC) FILETIME=[BF51F2F0:01C761CC]
Authentication-Results: sj-dkim-7; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim7002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > When ever I try and start a guest OS with kvm I get a lot of these rtc
 > missing interupt messages from the kernel
 > 
 > [  468.510878] rtc: lost some interrupts at 1024Hz.

I started to debug this a little while ago but I never got too far.
However it doesn't seem connected with kvm -- it is something to do
with tun/tap or bridging holding a lock too long I think.

Try running your guest with -no-kvm (and even with the kvm module not
loaded, just to be sure).  In my case I still saw the messages.
However, removing the "-net tap" line from my command line did get rid
of the messages.

 - R.
