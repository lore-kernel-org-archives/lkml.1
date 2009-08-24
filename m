Return-Path: <linux-kernel-owner+w=401wt.eu-S1752611AbZHXO2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbZHXO2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 10:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbZHXO2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 10:28:13 -0400
Received: from ns1.coraid.com ([12.51.113.4]:52376 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752482AbZHXO2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 10:28:13 -0400
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Mon, 24 Aug 2009 10:27:13 -0400
To: apw@canonical.com, ecashin@coraid.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] aoe: ensure we initialise the request_queue correctly
Message-ID: <9ab0e087296715d764071d4d39542985@coraid.com>
In-Reply-To: <1250872904-10993-1-git-send-email-apw@canonical.com>
References: <1250872904-10993-1-git-send-email-apw@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri Aug 21 12:41:59 EDT 2009, apw@canonical.com wrote:
> We have been seeing oopses in very recent kernels when using the AOE driver.
> When attempting to mount remote devices we get a warning from the kobject
> layer:
> 
>   [ 2645.959090] kobject '<NULL>' (ffff880059ca22c0): tried to add
> 	an uninitialized object, something is seriously wrong.
> 
> Looking at the driver it seems to have always had an embedded request_queue
> and it is this that is throwing the error.  It appears the intent is
> tha these would be allocated and released using helpers, and the lack of
> these leaves the object uninitialised and throws the error.  It is unclear
> how this could ever have worked.

This aoe driver does not handle I/O requests but provides its own
make_request function to blk_queue_make_request and handles bios
instead.

The reason I was interested in a git bisect is that I suspect that
before nobody was interested in the request_queue in the aoe driver
until recent changes to kobject code.  A couple people have indicated
that they'd be doing such a git bisect, so if anybody has done that,
please Cc me.

-- 
  Ed
