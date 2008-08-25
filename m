Return-Path: <linux-kernel-owner+w=401wt.eu-S1751043AbYHYEAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751043AbYHYEAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 00:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbYHYEA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 00:00:28 -0400
Received: from ozlabs.org ([203.10.76.45]:39864 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbYHYEA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 00:00:28 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] debug: fix BUILD_BUG_ON() for non-constant expressions
Date: Mon, 25 Aug 2008 11:19:09 +1000
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
References: <20080816100948.GB19926@martell.zuzino.mipt.ru> <20080819133422.GA24369@elte.hu> <48AAF5F7.6040709@panasas.com>
In-Reply-To: <48AAF5F7.6040709@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808251119.09916.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 August 2008 02:33:59 Boaz Harrosh wrote:
> If the user of virtio_has_feature() must pass a compile-time constant then
> it must be converted to a MACRO, and then the BUILD_BUG_ON will work.
> Or it should be changed to a BUG_ON() if fbit is a runtime variable.

I was (ab)using the current slackness of BUILD_BUG_ON() to be a noop on 
non-constants.  We can replace with a BUG_ON if we fix BUILD_BUG_ON() to 
insist on a compile-time constant; I think that's still an overall win.

Cheers,
Rusty.
