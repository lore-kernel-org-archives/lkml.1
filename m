Return-Path: <linux-kernel-owner+w=401wt.eu-S1755153AbZHTR5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbZHTR5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 13:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755053AbZHTR5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 13:57:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049AbZHTR5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 13:57:03 -0400
Date: Thu, 20 Aug 2009 20:55:41 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Davide Libenzi <davidel@xmailserver.org>, gleb@redhat.com,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
Message-ID: <20090820175540.GA9232@redhat.com>
References: <20090820155655.GA8764@redhat.com> <alpine.DEB.2.00.0908200916300.14844@makko.or.mcafeemobile.com> <4A8D8A28.2050004@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8D8A28.2050004@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 08:38:48PM +0300, Avi Kivity wrote:
> On 08/20/2009 07:20 PM, Davide Libenzi wrote:
>>
>> I briefly looked at this while in vacation, although I did not reply
>> hoping the horrible feeling about this code would go away.
>> It didn't.
>> I find this to be an ugly and ad-hoc multiplexing of eventfd with added
>> functionalities of questionable general use.
>> I'm pretty sure you can do better on KVM side, to solve the problem w/out
>> littering eventfd.
>>
>>    
>
> While we could argue about this my feeling is that we should drop this,  
> at least until we can quantify what benefit it has and whether there are  
> any Davide-acceptable alternatives.
>
> In the meanwhile, we can let vhost-net support edge-triggered interrupts  
> only, let qemu terminate those eventfds and convert then to  
> level-triggered interrupts (which it can then inject using the existing  
> ioctl).  It will keep vhost-net and kvm simpler at the cost of some  
> performance penalty to guests using level interrupts.  These suck anyway  
> so we'll point users at msi.

I thought the point was to move assigned devices out of KVM?

> -- 
> I have a truly marvellous patch that fixes the bug which thisb
> signature is too narrow to contain.
