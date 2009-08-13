Return-Path: <linux-kernel-owner+w=401wt.eu-S1752891AbZHMGcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbZHMGcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 02:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbZHMGce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 02:32:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50300 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbZHMGce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 02:32:34 -0400
Date: Thu, 13 Aug 2009 09:31:13 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Arnd Bergmann <arnd@arndb.de>, virtualization@lists.linux-foundation.org,
       "Ira W. Snyder" <iws@ovro.caltech.edu>, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vhost_net: a kernel-level virtio server
Message-ID: <20090813063113.GA3508@redhat.com>
References: <cover.1249930169.git.mst@redhat.com> <200908121903.22325.arnd@arndb.de> <20090812172141.GA29966@redhat.com> <200908121959.47222.arnd@arndb.de> <4A8317A3.4030303@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8317A3.4030303@codemonkey.ws>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 02:27:31PM -0500, Anthony Liguori wrote:
> Arnd Bergmann wrote:
>>> As I pointed out earlier, most code in virtio net is asymmetrical: guest
>>> provides buffers, host consumes them.  Possibly, one could use virtio
>>> rings in a symmetrical way, but support of existing guest virtio net
>>> means there's almost no shared code.
>>>     
>>
>> The trick is to swap the virtqueues instead. virtio-net is actually
>> mostly symmetric in just the same way that the physical wires on a
>> twisted pair ethernet are symmetric (I like how that analogy fits).
>>   
>
> It's already been done between two guests.  See  
> http://article.gmane.org/gmane.linux.kernel.virtualization/5423
>
> Regards,
>
> Anthony Liguori

Yes, this works by copying data (see PATCH 5/5).  Another possibility is
page flipping.  Either will kill performance.

-- 
MST
