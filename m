Return-Path: <linux-kernel-owner+w=401wt.eu-S1759741AbZDBLsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741AbZDBLsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758577AbZDBLs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:48:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44938 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756068AbZDBLs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:48:26 -0400
Message-ID: <49D4A5FB.1020601@redhat.com>
Date: Thu, 02 Apr 2009 14:48:11 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>, anthony@codemonkey.ws,
       andi@firstfloor.org, linux-kernel@vger.kernel.org, agraf@suse.de,
       pmullaney@novell.com, pmorreale@novell.com, rusty@rustcorp.com.au,
       netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
References: <20090402085253.GA29932@gondor.apana.org.au> <49D47F11.6070400@redhat.com> <49D49986.3060303@novell.com>
In-Reply-To: <49D49986.3060303@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:

  

>> There is no choice.  Exiting from the guest to the kernel to userspace
>> is prohibitively expensive, you can't do that on every packet.
>>
>>     
>
> Now you are making my point ;)  This is part of the cost of your
> signaling path, and it directly adds to your latency time.   

It adds a microsecond.  The kvm overhead of putting things in userspace 
is low enough, I don't know why people keep mentioning it.  The problem 
is the kernel/user networking interfaces.

> You can't
> buffer packets here if the guest is only going to send one and wait for
> a response and expect that to perform well.  And this is precisely what
> drove me to look at avoiding going back to userspace in the first place.
>   

We're not buffering any packets.  What we lack is a way to tell the 
guest that we're done processing all packets in the ring (IOW, re-enable 
notifications).

-- 
error compiling committee.c: too many arguments to function

