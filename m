Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbZJEQ2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbZJEQ2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 12:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbZJEQ2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 12:28:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbZJEQ2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 12:28:30 -0400
Message-ID: <4ACA1CBC.8020402@redhat.com>
Date: Mon, 05 Oct 2009 12:20:12 -0400
From: john cooper <john.cooper@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       john.cooper@redhat.com
Subject: Re: [PATCH 1/4] virtio_blk: deprecate the 1024-byte ID field.
References: <200909300248.09630.rusty@rustcorp.com.au> <200909300941.24736.borntraeger@de.ibm.com>
In-Reply-To: <200909300941.24736.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> Am Dienstag 29 September 2009 19:18:09 schrieb Rusty Russell:
>> PCI, lguest and s390 can all only support 256-byte configuration
>> space.  So, this giant field broke just about everyone.
>> Unfortunately, removing it is not so simple: we don't want to break
>> old userspace, but we're going to want to re-use that part of the
>> struct.
>>
>> So, modern users can #define VIRTIO_BLK_IDENTIFY_DEPRECATED to indicate
>> that they know it's no longer in the config struct, and can use any
>> new features (all new features which add a configuration field will
>> conflict with this deprecated one).
> 
> 
> Since s390 never used the giant id field, it would be ok for us just delete it 
> (without the #define). IIRC kvm-userspace also never used that. Since qemu 
> upstream seems to use that field your way seems to be the only compatible...

It seems simply retiring use of the VIRTIO_BLK_F_IDENTIFY
binary value should be sufficient.  The patch which
implemented the cooperating logic in qemu was dropped
due to the config space issue.  So the case of a virtio_blk
driver successfully negotiating the feature and trying to
access the now depreciated structure area should effectively
be a non-issue.  The bit value can be reclaimed for reuse
in the future when concern over any suspected usage falls
into the noise.

-john

-- 
john.cooper@redhat.com
