Return-Path: <linux-kernel-owner+w=401wt.eu-S1753055AbYJFExS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbYJFExS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 00:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbYJFExH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 00:53:07 -0400
Received: from ozlabs.org ([203.10.76.45]:37628 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbYJFExG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 00:53:06 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH/RFC 0/4] Add stop_machine_get/put_threads to stop_machine infrastructrue.
Date: Mon, 6 Oct 2008 14:42:40 +1000
User-Agent: KMail/1.9.9
References: <20081003105632.357231142@de.ibm.com>
In-Reply-To: <20081003105632.357231142@de.ibm.com>
Cc: jens.axboe@oracle.com, schwidefsky@de.ibm.com,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810061542.41224.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 October 2008 20:56:32 you wrote:
> However we need to be able to do that without allocating any memory.

Nice work Heiko!

See free_module(), which calls stop_machine and, well, just hopes it works.  
So we've needed this for a while.

> Patch 1 is a stop_machine bugfix and is independent of the rest

Hmm, do you actually need this?  It was a whim (and clearly a dumb one).  I'm 
tempted to change it to:

	err = smdata->fn(smdata->data);
	if (err)
		smdata->fnret = err;

> Patch 2 introduces the new proposed interface

Could we just encapsulate the threads etc. into a "struct stopmachine" which 
is returned from stop_machine_prepare(), then implement everything in terms 
of that?

Thanks,
Rusty.
