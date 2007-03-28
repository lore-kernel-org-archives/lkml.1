Return-Path: <linux-kernel-owner+w=401wt.eu-S1752245AbXC1O4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbXC1O4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 10:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbXC1O4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 10:56:09 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:16344 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752245AbXC1O4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 10:56:08 -0400
Message-ID: <460A7FBC.600@cfl.rr.com>
Date: Wed, 28 Mar 2007 10:46:20 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: Mike Snitzer <snitzer@gmail.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: forced umount?
References: <170fa0d20703162106v47dc13e1u1ae5381576f372ed@mail.gmail.com>  <45FB6E32.3050009@goop.org>  <170fa0d20703162237m1023cbd2o8ccf9e464c53f4a0@mail.gmail.com> <84144f020703170353y4490d0dcr24352c291c96300b@mail.gmail.com> <46083C79.1080108@cfl.rr.com> <Pine.LNX.4.64.0703270929030.31885@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0703270929030.31885@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Mar 2007 14:46:24.0608 (UTC) FILETIME=[DBB5A600:01C77147]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15082.000
X-TM-AS-Result: No--6.156300-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg wrote:
> We never want to _abort_ pending updates only pending reads. So, even with 
> revoke(), we need to be careful which is why we do do_fsync() in 
> generic_revoke_file() to make sure pending updates are flushed before we 
> declare the inode revoked.
> 
> But, I haven't looked at forced unmount that much so there may be other 
> issues I am not aware of.

For the purposes of this thread we _do_ want to abort pending updates to
force the system to give up on a broken block device rather than block a 
bunch of tasks in the D state forever.

