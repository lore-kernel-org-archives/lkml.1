Return-Path: <linux-kernel-owner+w=401wt.eu-S1753588AbZKVKjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbZKVKjs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 05:39:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbZKVKjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 05:39:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbZKVKjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 05:39:44 -0500
Date: Sun, 22 Nov 2009 12:35:11 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Xin, Xiaohui" <xiaohui.xin@intel.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "gregory.haskins@gmail.com" <gregory.haskins@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "s.hetze@linux-ag.com" <s.hetze@linux-ag.com>,
       Daniel Walker <dwalker@fifo99.com>,
       Eric Dumazet <eric.dumazet@gmail.com>, mashirle@us.ibm.com
Subject: Re: [PATCHv9 3/3] vhost_net: a kernel-level virtio server
Message-ID: <20091122103511.GB13644@redhat.com>
References: <cover.1257786516.git.mst@redhat.com> <20091109172230.GD4724@redhat.com> <C85CEDA13AB1CF4D9D597824A86D2B901925446AB4@PDSMSX501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C85CEDA13AB1CF4D9D597824A86D2B901925446AB4@PDSMSX501.ccr.corp.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 01:42:43PM +0800, Xin, Xiaohui wrote:
> Michael,
> >From the http://www.linux-kvm.org/page/VhostNet, we can see netperf with TCP_STREAM can get more than 4GMb/s for the receive side, and more than 5GMb/s for the send side.
> Is it the result from the raw socket or through tap?
> I want to duplicate such performance with vhost on my side. I can only get more than 1GMb/s with following conditions:
> 1) disabled the GRO feature in the host 10G NIC driver
> 2) vi->big_packet in guest is false
> 3) MTU is 1500.
> 4) raw socket, not the tap
> 5) using your vhost git tree
> 
> Is that the reasonable result with such conditions or maybe I have made some silly mistakes somewhere I don't know yet?
> May you kindly describe your test environment/conditions in detail to have much better performance in your website (I really need the performance)?
> 
> Thanks
> Xiaohui

These results where sent by Shirley Ma (Cc'd).
I think they were with tap, host-to-guest/guest-to-host

> And I have tested the tun support with vhost now, and may you share your /home/mst/ifup script here?
> 

These are usually pretty simple, mine looks like this:

#!/bin/sh -x
/sbin/ifconfig tap0 0.0.0.0 up
brctl addif br0 tap0

-- 
MST
