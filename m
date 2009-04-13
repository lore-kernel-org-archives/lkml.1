Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbZDMX5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbZDMX5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 19:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbZDMX4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 19:56:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751482AbZDMX4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 19:56:54 -0400
Date: Mon, 13 Apr 2009 16:54:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Malek <dan@embeddedalley.com>
Cc: linux-kernel@vger.kernel.org, menage@google.com,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH] Memory usage limit notification addition to memcg
Message-Id: <20090413165404.b6660aea.akpm@linux-foundation.org>
In-Reply-To: <298A09AD-495E-4671-84A1-B831826424A8@embeddedalley.com>
References: <1239660512-25468-1-git-send-email-dan@embeddedalley.com>
	<20090413160814.1c335d1d.akpm@linux-foundation.org>
	<298A09AD-495E-4671-84A1-B831826424A8@embeddedalley.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Apr 2009 16:45:17 -0700
Dan Malek <dan@embeddedalley.com> wrote:

> On Apr 13, 2009, at 4:08 PM, Andrew Morton wrote:
> 
> > We've run into problems in the past where a percentage number is too
> > coarse on large-memory systems.
> >
> > Proabably that won't be an issue here, but I invite you to convince us
> > of this ;)
> 
> The challenge here is that the absolute limit of the memcg can
> be dynamically changed, so I wanted to avoid a couple of problems.
> One is just a system configuration error where someone forgets
> to modify both.  For example, if you start with the memcg limit of 100M,
> and the notification limit to 80M, then come back and change the memcg
> limit to 90M (or worse, < 80M) you now have a clearly incorrect
> configuration.   Another problem is the operation isn't atomic, at some
> point during the changes, even if you remember to do it correctly, you
> will have the two values not representing what you really want.  It
> could trigger an erroneous notification, or simply OOM kill before you
> get the configuration correct.
> 
> If an integer number turns out to not be sufficient, we could change  
> this
> to some fixed point representation and adjust the arithmetic in the  
> tests.
> I believe the integer number will be fine, even in large memory systems.
> This is just a notification model, if we want something more fine  
> grained
> I believe it would need different semantics.

I agree.  But it would be a mighty mess if we were to turn around in
two years time and add a second centi-percent interface.  So we should
give this careful thought now and really convince ourselves that we
will never ever ever want sub-1% resolution.


