Return-Path: <linux-kernel-owner+w=401wt.eu-S1764111AbZLQIal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764111AbZLQIal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 03:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759308AbZLQIak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 03:30:40 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50592 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759289AbZLQIaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 03:30:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=ofTDvzd1yy8C7KbhKWAh7+2ojbgTQ7nXRBxz5L+gZjiWoOikG8ZqvhlvBGb+l2j95w
         lZnf4E5Y1nohF1Rjxp8HMJrIAX2iMSu7Lrnz0+JghMlZdUL11sMnFXqMrcpjyBZxv3Db
         UUBIgbI8I3VVKT/xpZYH1rK0T5l2M6uluc86Q=
Date: Thu, 17 Dec 2009 10:30:46 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mark Hounschell <markh@compro.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Unable to format or use floppies since 2.6.28
Message-ID: <20091217083046.GD2121@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Mark Hounschell <markh@compro.net>, linux-kernel@vger.kernel.org
References: <4B215007.4030703@compro.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B215007.4030703@compro.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 02:46:15PM -0500, Mark Hounschell wrote:
> I have many boxes. They all do the same thing. Running different 
> versions of SuSE, 10.3-11.2. Any kernel at or above 2.6.28 fails to 
> fdformat a floppy. These same machines, using the same floppies and 
> drives, running kernels older than 2.6.28 work just fine. I googled 
> and found other such reports but no solution. I know better than to 
> just assume it's a kernel bug but it sure looks like it could be so 
> I'm inquiring about it here. 
> 

I don't know if this is related to your bug, but it's a weirdness in 
floppy.c (from 2.6.32-rc8 sorry I suck for being up to date).

drivers/block/floppy.c 
  2532          size = blk_rq_cur_bytes(current_req);
  2533
  2534          rq_for_each_segment(bv, current_req, iter) {
  2535                  if (!remaining)
  2536                          break;
  2537
  2538                  size = bv->bv_len;
 
We never use the first size = blk_rq_cur_bytes() assignment.

regards,
dan carpenter
