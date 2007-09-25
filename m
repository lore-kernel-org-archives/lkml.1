Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbXIYDWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbXIYDWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 23:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbXIYDV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 23:21:57 -0400
Received: from ozlabs.org ([203.10.76.45]:58330 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbXIYDV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 23:21:56 -0400
Subject: Re: [PATCH 1/4] module: implement module_inhibit_unload()
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <htejun@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, ebiederm@xmission.com,
       cornelia.huck@de.ibm.com, greg@kroah.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
In-Reply-To: <46F874DB.5070205@gmail.com>
References: <25380.1190671205@lwn.net>  <46F845B2.7030002@gmail.com>
	 <1190677332.27805.229.camel@localhost.localdomain>
	 <46F86727.4050004@gmail.com>
	 <1190686320.27805.258.camel@localhost.localdomain>
	 <46F874DB.5070205@gmail.com>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 13:21:33 +1000
Message-Id: <1190690493.27805.263.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-25 at 11:39 +0900, Tejun Heo wrote:
> Rusty Russell wrote:
> >>> I really wonder if an explicit "kill_this_attribute()" is a better way
> >>> to go than this...
> >> I think this sort of temporary unload blocking would be useful for other
> >> cases like this.
> > 
> > I hope not: this doesn't work in general.  Calling into a module after
> > ->exit has called assumes that the exit function doesn't free up or
> > overwrite stuff the other functions need.
> 
> Right, the sole purpose the unload inhibition is to hold onto the 'code'
> section from going away.  The rest of object lifetime management should
> be implemented using separate mechanisms anyway.  I was talking about
> similar cases where the 'code' should be protected for a short time.

As stated you cannot protect arbitrary code this way, as you are trying
to do.  I do not think you've broken any of the current code, but I
cannot tell.  You're certainly going to surprise unsuspecting future
authors.

Can you really not figure out the module owner of the sysfs entry to inc
its use count during this procedure?  (__module_get()).

Rusty.

