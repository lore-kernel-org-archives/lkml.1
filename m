Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbZCFT0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbZCFT0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbZCFT0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:26:01 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:36190 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbZCFT0A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:26:00 -0500
X-BigFish: VPS-30(zz146fK1432R98dR1805M936fKzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KG3NAJ-03-CN7-01
Date: Fri, 6 Mar 2009 20:25:35 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 03/18] dma-debug: add hash functions for dma_debug_entries
Message-ID: <20090306192535.GD6966@amd.com>
References: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com> <1236346229-6618-4-git-send-email-joerg.roedel@amd.com> <20090306135052.GE5988@nowhere> <20090306184514.GE7420@localhost> <20090306191059.GE7329@nowhere> <20090306191641.GF7420@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20090306191641.GF7420@localhost>
User-Agent: mutt-ng/devel-r804 (Linux)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 06 Mar 2009 19:25:35.0759 (UTC) FILETIME=[530D31F0:01C99E91]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 10:16:41PM +0300, Cyrill Gorcunov wrote:
> [Frederic Weisbecker - Fri, Mar 06, 2009 at 08:11:00PM +0100]
> | On Fri, Mar 06, 2009 at 09:45:14PM +0300, Cyrill Gorcunov wrote:
> | > [Frederic Weisbecker - Fri, Mar 06, 2009 at 02:50:52PM +0100]
> | > ...
> | > | > +/*
> | > | > + * Add an entry to a hash bucket
> | > | > + */
> | > | > +static void hash_bucket_add(struct hash_bucket *bucket,
> | > | > +			    struct dma_debug_entry *entry)
> | > | > +{
> | > | > +	list_add_tail(&entry->list, &bucket->list);
> | > | > +}
> | > | > +
> | > | > +/*
> | > | > + * Remove entry from a hash bucket list
> | > | > + */
> | > | > +static void hash_bucket_del(struct dma_debug_entry *entry)
> | > | > +{
> | > | > +	list_del(&entry->list);
> | > | > +}
> | > | 
> | > | 
> | > | Perhaps the two wrappers above are unnecessary, since they are actually
> | > | used once and only wrap a single list operation. No?
> | > | 
> | > | Frederic.
> | > 
> | > Hi Frederic,
> | > 
> | > I think it would be better to make them 'inline' only but remain
> | > the wrappers as is, since it show logic flow and hides internal data
> | > details. But it's my personal opinion.
> | 
> | 
> | Yeah, I guess it's only a matter of taste :-)
> | Anyway, as you said, it should be inlined.
> 
> Nod :) The only problem could be (it depends) -- is that
> if one day some locking would be needed instead of fixing
> one function you would need to grep all list_add/del entries :)

The access is already locked. And as the functions are only called
once each gcc should inline them automatically. At least gcc inlined
them in my kernels :)

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

