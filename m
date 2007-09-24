Return-Path: <linux-kernel-owner+w=401wt.eu-S1761325AbXIXXnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761325AbXIXXnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 19:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947AbXIXXnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 19:43:00 -0400
Received: from ozlabs.org ([203.10.76.45]:57611 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923AbXIXXnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 19:43:00 -0400
Subject: Re: [PATCH 1/4] module: implement module_inhibit_unload()
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <htejun@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, ebiederm@xmission.com,
       cornelia.huck@de.ibm.com, greg@kroah.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
In-Reply-To: <46F845B2.7030002@gmail.com>
References: <25380.1190671205@lwn.net>  <46F845B2.7030002@gmail.com>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 09:42:12 +1000
Message-Id: <1190677332.27805.229.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-25 at 08:18 +0900, Tejun Heo wrote:
> > Given your description of this tool as a "sledgehammer," might it not be
> > easier to just take and hold module_mutex for the duration of the unload
> > block?
> 
> That would be easier but...
> 
> * It would serialize users of the sledgehammer.
> * It would block loading modules (which is often more important than
> unloading them) when things go south.

My concern is that you're dropping the module mutex around ->exit now.
I don't *think* this should matter, but it's worth considering.

I really wonder if an explicit "kill_this_attribute()" is a better way
to go than this...

Rusty.

