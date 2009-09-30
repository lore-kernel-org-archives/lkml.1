Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194AbZI3Hlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbZI3Hlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 03:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbZI3Hls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 03:41:48 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:56821 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbZI3Hls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 03:41:48 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/4] virtio_blk: deprecate the 1024-byte ID field.
Date: Wed, 30 Sep 2009 09:41:24 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-release; KDE/4.3.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, john cooper <john.cooper@redhat.com>,
       virtualization@lists.linux-foundation.org
References: <200909300248.09630.rusty@rustcorp.com.au>
In-Reply-To: <200909300248.09630.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909300941.24736.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 29 September 2009 19:18:09 schrieb Rusty Russell:
> PCI, lguest and s390 can all only support 256-byte configuration
> space.  So, this giant field broke just about everyone.
> Unfortunately, removing it is not so simple: we don't want to break
> old userspace, but we're going to want to re-use that part of the
> struct.
> 
> So, modern users can #define VIRTIO_BLK_IDENTIFY_DEPRECATED to indicate
> that they know it's no longer in the config struct, and can use any
> new features (all new features which add a configuration field will
> conflict with this deprecated one).


Since s390 never used the giant id field, it would be ok for us just delete it 
(without the #define). IIRC kvm-userspace also never used that. Since qemu 
upstream seems to use that field your way seems to be the only compatible...

O dear, virtio used to look pretty ;-).
I think somewhen in the future we have to create a virtio2 that gets rid of all 
the stuff that accumulated in the early phase of Linux virtualization.

Anyway, your patch was tested successfully on s390 to survive the current 
userspace.

Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
