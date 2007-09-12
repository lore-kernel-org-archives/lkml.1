Return-Path: <linux-kernel-owner+w=401wt.eu-S932729AbXILCcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729AbXILCcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 22:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbXILCcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 22:32:45 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:55109 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbXILCco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 22:32:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18151.20356.862163.430265@stoffel.org>
Date: Tue, 11 Sep 2007 22:31:32 -0400
From: "John Stoffel" <john@stoffel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, torvalds@linux-foundation.org
Subject: Re: [PATCH 00/23] per device dirty throttling -v10
In-Reply-To: <20070911195350.825778000@chello.nl>
References: <20070911195350.825778000@chello.nl>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Peter> Per device dirty throttling patches These patches aim to
Peter> improve balance_dirty_pages() and directly address three
Peter> issues:

Peter>   1) inter device starvation
Peter>   2) stacked device deadlocks
Peter>   3) inter process starvation

Peter> 1 and 2 are a direct result from removing the global dirty
Peter> limit and using per device dirty limits. By giving each device
Peter> its own dirty limit is will no longer starve another device,
Peter> and the cyclic dependancy on the dirty limit is broken.

Ye haa!  This should be a big improvement.  

Peter> In order to efficiently distribute the dirty limit across the
Peter> independant devices a floating proportion is used, this will
Peter> allocate a share of the total limit proportional to the
Peter> device's recent activity.

I'm not sure I like or agree with this.  Shouldn't we be limiting
based on the device's capability to sustain traffic?  So if I have a
RAID device which can read/write a total of 100Mb/sec, while at the
same time I've got a CF device which can do 5Mb/sec, shouldn't we be
more strongly limiting the CF device, even if it is the only device
being written to?  

Of course, I haven't read the patches yet, nor am I qualified to
comment on them in any meanginful way I think.  Hopefully I'm just
missing something key here in the explanation.

Peter> 3 is done by also scaling the dirty limit proportional to the
Peter> current task's recent dirty rate.

Do you mean task or device here?  I'm just wondering how well this
works with a bunch of devices with wildly varying speeds.  

John
