Return-Path: <linux-kernel-owner+w=401wt.eu-S1758364AbZJJX1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364AbZJJX1y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 19:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbZJJX1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 19:27:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:57396 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052AbZJJX1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 19:27:52 -0400
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Josua Dietze <digidietze@draisberghof.de>, Ben Efros <ben@pc-doctor.com>,
       fangxiaozhi <huananhu@huawei.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Hugh Blemings <hugh@blemings.org>
In-Reply-To: <Pine.LNX.4.44L0.0910101851430.7922-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0910101851430.7922-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Oct 2009 10:26:26 +1100
Message-Id: <1255217186.2192.18.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-10 at 18:52 -0400, Alan Stern wrote:
> > Maybe a better approach would be to go back to 18 bytes when it fails,
> > what do you think ?
> 
> We certainly could do that.  But should we turn off the SANE_SENSE flag 
> at the same time? 

I would think so, and not set it back the next time the sense buffer
claims more data in it (something like setting a NOT_REALLY_SANE_SENSE
flag ? :-)

Or not care and always do double sense on those devices. Whatever
works. It's not that sense was a fast path.

Cheers,
Ben.


