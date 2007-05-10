Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbXEJQLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbXEJQLD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 12:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbXEJQKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 12:10:55 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:60794 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbXEJQKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 12:10:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=unDJHOHxECvXWX3f7GrazSKjpN9b5n4yhbE+yfiXsB0qMXGQK3jY7CAikv4i3hT+Ho8oyzKiq8kpa9qd8gwlVck2AJS8VdHRp0sKbFjQoOjhDBbZycrwOXFq7DbfDbQITpNbjSn3zNtA1oaE0FNvW5+wspExPA/bl+hstG95g6M=
Message-ID: <46434378.1020900@gmail.com>
Date: Thu, 10 May 2007 18:08:24 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       rusty@rustcorp.com.au, ak@suse.de, jens.axboe@oracle.com
Subject: Re: [patch 8/9] lguest: the block driver
References: <200705090951.l499pdsc020409@shell0.pdx.osdl.net> <84144f020705090322jc37884drc31b97879648d09@mail.gmail.com>
In-Reply-To: <84144f020705090322jc37884drc31b97879648d09@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2007 12:22 PM, Pekka Enberg wrote:

>> +static void end_entire_request(struct request *req, int uptodate)
>> +{
>> +       if (end_that_request_first(req, uptodate, req->hard_nr_sectors))
>> +               BUG();
>> +       add_disk_randomness(req->rq_disk);
>> +       blkdev_dequeue_request(req);
>> +       end_that_request_last(req, uptodate);
>> +}
> 
> Again, I would prefer this went straight into block/ll_rw_blk.c. Rene
> and I am using something similar in the new Mitsumi driver although
> one of us has a bug already, we're using req->nr_sectors for this...

The req->hard_nr_sectors is specifically marked block layer internal and 
since nr_sectors is what we're requesting and reading (we can't deal with 
partial transfers anyway since the drive won't tell us where it failed as 
far as I've been able to see and we do want to make read requests for as 
many sectors as possible at a time for speed) I believe that in our case the 
nr_sectors is fine.

Rene.

