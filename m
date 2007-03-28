Return-Path: <linux-kernel-owner+w=401wt.eu-S965663AbXC1Syf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965663AbXC1Syf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 14:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965661AbXC1Syf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 14:54:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:33016 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965658AbXC1Sye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 14:54:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,341,1170662400"; 
   d="scan'208"; a="220975894:sNHT21910504"
Message-ID: <460AB9E8.8070803@intel.com>
Date: Wed, 28 Mar 2007 11:54:32 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.10 (X11/20070311)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>, Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       e1000-devel@lists.sourceforge.net, jgarzik@pobox.com,
       netdev@vger.kernel.org
Subject: Re: [1/5] 2.6.21-rc5: known regressions
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070327015929.GY16477@stusta.de>
In-Reply-To: <20070327015929.GY16477@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Mar 2007 18:54:33.0708 (UTC) FILETIME=[864E02C0:01C7716A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Subject    : e1000 resume weirdness
> References : http://lkml.org/lkml/2007/3/26/91
> Submitter  : Ingo Molnar <mingo@elte.hu>
> Handled-By : Jesse Brandeburg <jesse.brandeburg@gmail.com>
>              Auke Kok <auke-jan.h.kok@intel.com>
> Status     : problem is being debugged

The issue comes from a corner case and the underlying problem is that e1000 
isn't stopping tx properly. We have a fix for this pending in our tree that I'll 
push upstream for 2.6.22 to Jeff, but I don't think this should be a blocker and 
it's probably is not a regression at all, the gap has always been present.

on a side note, this is probably fixed easily by turning the adapters 
detect_tx_hung flag off in e1000_down, so if someone spots this reoccurring 
somewhat regularly, please contact me so we can debug it. I myself have a system 
suspend/resuming in circles for an hour now with traffic flying across without a 
single hit on it....

Adrian, you probably want to drop this issue from your list.

Cheers,


Auke
