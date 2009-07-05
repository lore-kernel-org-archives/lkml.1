Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbZGEKRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbZGEKRM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 06:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbZGEKRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 06:17:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33573 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbZGEKRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 06:17:00 -0400
Date: Sun, 5 Jul 2009 13:16:24 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: [KVM PATCH v9 0/5] irqfd fixes and enhancements
Message-ID: <20090705101623.GA3014@redhat.com>
References: <20090702153454.20186.99191.stgit@dev.haskins.net> <4A4CD729.6050300@redhat.com> <4A50723E.6030305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A50723E.6030305@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 05, 2009 at 12:28:30PM +0300, Avi Kivity wrote:
> On 07/02/2009 06:50 PM, Avi Kivity wrote:
>> On 07/02/2009 06:37 PM, Gregory Haskins wrote:
>>> (Applies to kvm.git/master:1f9050fd)
>>>
>>> The following is the latest attempt to fix the races in  
>>> irqfd/eventfd, as
>>> well as restore DEASSIGN support.  For more details, please read the  
>>> patch
>>> headers.
>>>
>>> As always, this series has been tested against the kvm-eventfd unit test
>>> and everything appears to be functioning properly. You can download this
>>> test here:
>>
>> Applied, thanks.
>>
>
> ... and unapplied.  There's a refcounting mismatch in irqfd_cleanup: a  
> reference is taken for each irqfd, but dropped for each guest.  This  
> causes an oops if a guest with no irqfds is created and destroyed:

Ugh, apparently this logic has been changed between I acked v7 of the
patches and between Avi applied v9. Will have to find the time to redo
the review - or maybe just go back to v7? Is on-demand wq creation
really that important?

-- 
MST
