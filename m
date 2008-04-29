Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbYD2CIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbYD2CIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 22:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbYD2CHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 22:07:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38596 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbYD2CHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 22:07:53 -0400
Message-ID: <481682D6.5010207@zytor.com>
Date: Mon, 28 Apr 2008 19:07:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 0/2] Immediate Values - jump patching update
References: <20080428033415.303000651@polymtl.ca> <481607AF.80803@zytor.com> <20080428202552.GG15840@elte.hu> <48163B84.90605@zytor.com> <20080428221122.GC16153@elte.hu> <48164EE6.8010506@zytor.com> <20080428224438.GA6974@elte.hu> <48165866.5060403@zytor.com> <20080429014623.GA6284@Krystal>
In-Reply-To: <20080429014623.GA6284@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> Peter, do you have something like the following code in mind ?
> 

Basically, although I was suggesting using a per-site dynamic piece of 
code.  Data items may not necessarily be in registers.

> I think the main differences between the code snippet down here and the
> markers is that markers rely on the compiler to generate the stack
> setup, and have this code a little bit closer to the function than what
> I propose here, where I put the stack setup code in a "farfaraway"
> section.  Moreover, markers are much simpler than what I show here.
> And actually, markers can be deployed portably, with
> architecture-specific optimizations refined later. This has to be
> implemented all up front for any traced architecture. In addition,
> dealing with weird types like unsigned long long can become a pain.
> Also, due to fact that we are asking the compiler to put keep some
> variables live in registers, I would be tempted to embed this in a block
> controlled by an if() statement (conditional branch, like I use for the
> markers) so we don't have to pay the penality of populating the
> registers when not required if there are not live at the marker site.

We're requesting to keep them *alive*, but not necessarily in registers 
(that would be an "r" constraint.)

	-hpa
