Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933656Ab0BEBHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 20:07:22 -0500
Received: from sentry-three.sandia.gov ([132.175.109.17]:33177 "EHLO
	sentry-three.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933609Ab0BEBHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 20:07:20 -0500
X-WSS-ID: 0KXCGGE-08-CMQ-02
X-M-MSG: 
X-Server-Uuid: AF72F651-81B1-4134-BA8C-A8E1A4E620FF
Subject: Re: [PATCH] seastar - SeaStar Ethernet driver
From: "Kevin Pedretti" <ktpedre@sandia.gov>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
cc: "David Miller" <davem@davemloft.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100204231621.7a13695a@lxorguk.ukuu.org.uk>
References: <20100202205845.GE5246@hawkeye.sandia.gov>
 <20100202.134251.15604523.davem@davemloft.net>
 <1265160242.15726.20.camel@hawkeye.sandia.gov>
 <20100202.174045.135005544.davem@davemloft.net>
 <1265324464.23523.51.camel@hawkeye.sandia.gov>
 <20100204231621.7a13695a@lxorguk.ukuu.org.uk>
Date: Thu, 4 Feb 2010 17:59:23 -0700
Message-ID: <1265331563.23523.100.camel@hawkeye.sandia.gov>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.1
X-TMWD-Spam-Summary: TS=20100205010712; ID=1; SEV=2.3.1;
 DFV=B2010020501; IFV=NA; AIF=B2010020501; RPD=5.03.0010; ENG=NA;
 RPDID=7374723D303030312E30413031303230372E34423642364634302E303043353A534346535441543838363133332C73733D312C6667733D30;
 CAT=NONE; CON=NONE; SIG=AAAAAAAAAAAAAAAAAAAAAAAAfQ==
X-MMS-Spam-Filter-ID: B2010020501_5.03.0010
X-WSS-ID: 6775B0B52DG2141254-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-04 at 16:16 -0700, Alan Cox wrote:
> - tcpdump etc once coaxed would display seastar frames not fake ethernet
> - the config tools would actually report what it really was
> - non IP layers and userspace won't keep trying to do things you don't
>   want (what does it do right now with vlans I wonder 8))
> - there will be no ARP confusion
> 
> If it wants to stay compatible and pretend to be ethernet you probably
> need a message type for "encapsulated ethernet", you can then encapsulate
> anything not IP and stay compatible by keeping IP sent the way it is
> now ? Thats if it wants to in the first place.

I agree the current situation is rather confusing and a lot or most of
the standard tools will break.  I have used tcpdump with some success,
but I'm sure there's lots of stuff broken.

We do need to stay compatible with the existing proprietary driver.  The
usage model we're after is leaving all of the service nodes (nodes users
login to, serve I/O, etc.) booted with the existing proprietary software
and rebooting the compute nodes (99% of the nodes) with a modern Linux
kernel running this open-source seastar driver.  The compute nodes need
to be able to communicate with each other and with the service nodes
using IP (point-to-point).  Users login to the service nodes and then,
for example, can ssh to compute nodes, scp files to compute nodes,
etc.  

Probably critical background: each service node and each compute node
has a seastar NIC that directly connects to nearest neighbors, forming a
3-D torus.  The only way for the nodes to communicate is via this
network. 

I like the idea of encapsulating whole ethernet frames in a new message
type.  But won't the lack of broadcast (and multi-cast) still be an
issue for most protocols?  I also don't have much control over the
seastar header, but can probably find an ignored bit somewhere to mark
the new message type.

Kevin


