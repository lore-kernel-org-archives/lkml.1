Return-Path: <linux-kernel-owner+w=401wt.eu-S1763057AbZDCLDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763057AbZDCLDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 07:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763684AbZDCLDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 07:03:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33149 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763505AbZDCLDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 07:03:20 -0400
Message-ID: <49D5ED11.2000800@redhat.com>
Date: Fri, 03 Apr 2009 14:03:45 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>, ghaskins@novell.com,
       anthony@codemonkey.ws, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
References: <20090402085253.GA29932@gondor.apana.org.au> <49D47F11.6070400@redhat.com> <49D5EBE1.8030200@redhat.com>
In-Reply-To: <49D5EBE1.8030200@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gerd Hoffmann wrote:
> Avi Kivity wrote:
>   
>> There is no choice.  Exiting from the guest to the kernel to userspace
>> is prohibitively expensive, you can't do that on every packet.
>>     
>
> I didn't look at virtio-net very closely yet.  I wonder why the
> notification is that a big issue though.  It is easy to keep the number
> of notifications low without increasing latency:
>
> Check shared ring status when stuffing a request.  If there are requests
> not (yet) consumed by the other end there is no need to send a
> notification.  That scheme can even span multiple rings (nics with rx
> and tx for example).
>   

If the host is able to consume a request immediately, and the guest is 
not able to batch requests, this breaks down.  And that is the current 
situation.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

