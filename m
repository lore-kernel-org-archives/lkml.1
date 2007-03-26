Return-Path: <linux-kernel-owner+w=401wt.eu-S1752880AbXCZPuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbXCZPuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 11:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbXCZPuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 11:50:21 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:35655 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbXCZPuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 11:50:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B5w0J5zI/7Ac3ZnzXthKDtxEcllJXIrloNuAXSZDdiYwRcYXiL7ZdQ5Nau2gNzzpQ46G9+oMl3/bXV8zOOpBxiFXKE2Rqo4VPTtGpdBJqcCe9myouXQQ9hgHmBIbRFFKlK4eZUNc/CUs+m39sYmFcXThwMEGrSXeFuMVaK8LRGE=
Message-ID: <4807377b0703260850g5b20df6eo5279760b5c10e946@mail.gmail.com>
Date: Mon, 26 Mar 2007 08:50:19 -0700
From: "Jesse Brandeburg" <jesse.brandeburg@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: -rc5: e1000 resume weirdness
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       auke-jan.h.kok@intel.com, "Adrian Bunk" <bunk@stusta.de>
In-Reply-To: <20070326101153.GA4593@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
	 <20070326101153.GA4593@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/26/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> hm, on a T60, after suspend/resume, i get an e1000 timeout:
>
> e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
> e1000: eth0: e1000_clean_tx_irq: Detected Tx Unit Hang
>   Tx Queue             <0>
>   TDH                  <ec>
>   TDT                  <ec>
>   next_to_use          <ec>
>   next_to_clean        <82>
> buffer_info[next_to_clean]
>   time_stamp           <fffcc3db>
>   next_to_watch        <82>
>   jiffies              <fffd5da0>
>   next_to_watch.status <1>
>
> it works fine after that reset. The e1000 driver didnt do this before
> after resume the network was always available immediately. So this
> appears to be a relatively new regression (post-rc3 or so). high-res
> timers was disabled.

was there a "NETDEV WATCHDOG" message that follows this?  If not it is
a harmless debug print.  Note the time_stamp and jiffies difference,
very large, consistent with a resume.  I think we need to disable the
internal e1000 tx hang code that causes this debug print when we are
suspending.  I'll work with auke to generate a short patch.
