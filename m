Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbXFYIrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbXFYIrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 04:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbXFYIrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 04:47:32 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:16015 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbXFYIrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 04:47:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lP0AeuKuYPXIdX93miv4ptIr0ljNIWa5ygFTRD3RTHp4eBB+VGlnR5/dRKI1silYM3TL6See455oikmV0xFQBVUhQ/QBX1K2n9j8m/v6IM68AxNBbkkMUyPK81d98n3r8wN2ZyNMRkFlTwwHM2AUHtLFGVVSiJb40ENQuZ9T3vw=
Message-ID: <7e63f56c0706250147w508d3aeay5f7aaca8215953c8@mail.gmail.com>
Date: Mon, 25 Jun 2007 11:47:31 +0300
From: "Robert Iakobashvili" <coroberti@gmail.com>
To: djones@rossove.com
Subject: Re: Scaling Max IP address limitation
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <467F063A.2030805@rossove.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <467EA7C1.4080006@rossove.com>
	 <20070624110236.fa36b2f9.akpm@linux-foundation.org>
	 <7e63f56c0706241259u6e123ed6yc02b76f0260adaa5@mail.gmail.com>
	 <467F063A.2030805@rossove.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On 6/25/07, David Jones <djones@rossove.com> wrote:

> >> > I am trying to add multiple IP addresses ( v6 ) to my FC7 box on eth0.
> >> > But I am hitting a max limit of 4000 IP address . Seems like there
> >> is a
> >> > limiting variable in linux kernel (which one? ) that prevents from
> >> > adding more IP addresses than 4096. What do I need to change in Linux
> >> > kernel  ( and then recompile ) to be able to add more IP addresses
> >> than 4K addresses per system? ..
> >
> I am using the "ip add " command looping sequentially up until RTNETLINK
> starts refusing to add more IP addresses.
> How are you adding via Netlink interface ?

Yes.

OK. Now it looks that I am reproducing something.

Running curl-loader with 60K.conf (edit the name of interface) configuration:
#ulimit -n 80000
#curl-loader -f ./conf-examples/60K.conf -w
 it adds successfully 60 000 secondary IPv4 addresses as seen by
#ip addr | wc -l

When I tryed adding IPv6 addresses, using ipv6.conf with addresses
range edited:
IP_ADDR_MIN=  2001:db8:fff5:1::1
IP_ADDR_MAX= 2001:db8:fff5:ffff::1

I am getting after initial successes some errors:
"rtnl_talk(): RTNETLINK answers: Cannot allocate memory"
and
#ip addr | wc-l is 8194.

8K addresses added and no more? It might be a memory issue. Y can dig
into the code and look into the allocation process and limits on the
kernel memory for IPv6.

The physical memory on my computer is 480 MB.
kernel is vanilla 2.6.20.7.

Try to see, what happens, when you increase the memory on your comp,
if an option.

-- 
Sincerely,
Robert Iakobashvili,
coroberti %x40 gmail %x2e com
...........................................................
http://curl-loader.sourceforge.net
A web testing and traffic generation tool.
