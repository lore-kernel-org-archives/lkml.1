Return-Path: <linux-kernel-owner+w=401wt.eu-S933574AbZHWObr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574AbZHWObr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 10:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933471AbZHWObq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 10:31:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933460AbZHWObq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 10:31:46 -0400
Date: Sun, 23 Aug 2009 17:30:22 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Davide Libenzi <davidel@xmailserver.org>, gleb@redhat.com,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
Message-ID: <20090823143021.GA27495@redhat.com>
References: <20090820155655.GA8764@redhat.com> <alpine.DEB.2.00.0908200916300.14844@makko.or.mcafeemobile.com> <4A8D8A28.2050004@redhat.com> <20090820175540.GA9232@redhat.com> <4A8D90BB.2030506@redhat.com> <20090820182847.GB9282@redhat.com> <4A913DA9.1020403@redhat.com> <20090823133620.GA12841@redhat.com> <4A9146E3.2090007@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9146E3.2090007@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 23, 2009 at 04:40:51PM +0300, Avi Kivity wrote:
> On 08/23/2009 04:36 PM, Michael S. Tsirkin wrote:
>> More important here is realization that eventfd is a mutex/semaphore
>> implementation, not a generic event reporting interface as we are trying
>> to use it.
>>    
>
> Well it is a generic event reporting interface (for example, aio uses it).

Davide, I think it's a valid point.  For example, what read on eventfd
does (zero a counter and return) is not like any semaphore I saw.

Look at eventfd as pipe replacement: for wake-up between processes, it
works well. But what if we want to pass around some kind of key as well?
pipe lets you pass single-byte values atomically. This flag allows us to
use 8 byte values as keys.

> -- 
> error compiling committee.c: too many arguments to function
