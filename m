Return-Path: <linux-kernel-owner+w=401wt.eu-S1764382AbZDCLp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764382AbZDCLp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 07:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762068AbZDCLpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 07:45:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45109 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761888AbZDCLpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 07:45:41 -0400
Message-ID: <49D5F6FC.5090401@redhat.com>
Date: Fri, 03 Apr 2009 14:46:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Gerd Hoffmann <kraxel@redhat.com>, ghaskins@novell.com,
       anthony@codemonkey.ws, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
References: <20090402085253.GA29932@gondor.apana.org.au> <49D47F11.6070400@redhat.com> <49D5EBE1.8030200@redhat.com> <49D5ED11.2000800@redhat.com> <20090403111242.GA10200@gondor.apana.org.au>
In-Reply-To: <20090403111242.GA10200@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> On Fri, Apr 03, 2009 at 02:03:45PM +0300, Avi Kivity wrote:
>   
>> If the host is able to consume a request immediately, and the guest is  
>> not able to batch requests, this breaks down.  And that is the current  
>> situation.
>>     
>
> Hang on, why is the host consuming the request immediately? It
> has to write the packet to tap, which then calls netif_rx_ni so
> it should actually go all the way, no?
>   

The host writes the packet to tap, at which point it is consumed from 
its point of view.  The host would like to mention that if there was an 
API to notify it when the packet was actually consumed, then it would 
gladly use it.  Bonus points if this involves not copying the packet.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

