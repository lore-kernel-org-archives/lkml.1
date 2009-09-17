Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbZIQJMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbZIQJMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 05:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755191AbZIQJMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 05:12:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59425 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753891AbZIQJMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 05:12:08 -0400
Message-ID: <4AB1FE6E.9000201@cn.fujitsu.com>
Date: Thu, 17 Sep 2009 17:16:30 +0800
From: Shan Wei <shanwei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Xiaotian Feng <dfeng@redhat.com>
CC: davem@davemloft.net, kaber@trash.net, yoshfuji@linux-ipv6.org,
       jmorris@namei.org, pekkas@netcore.fi, kuznet@ms2.inr.ac.ru,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marc Milgram <mmilgram@redhat.com>
Subject: Re: [PATCH 2/2] ipv4: make do_ip_setsockopt for IP_MULTICAST_IF support
 ip_mreq struct
References: <1253164811-15820-1-git-send-email-dfeng@redhat.com>
In-Reply-To: <1253164811-15820-1-git-send-email-dfeng@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiaotian Feng wrote, at 09/17/2009 01:20 PM:
> ip_mreq and ip_mreqn is almost the same, and do_ip_setsockopt for IP_MULTICAST_IF
> part supported ip_mreqn struct. This patch adds support for ip_mreq struct.
> 

It's not meaning to support the ip_mreq struct, the imr_multiaddr member
never be used by the IP_MULTICAST_IF.

In addition, using the option normally like this: 
  struct in_addr interface_addr;
  setsockopt (socket, IPPROTO_IP, IP_MULTICAST_IF, &interface_addr, sizeof(interface_addr));
 
Do your patch suggest using the option like this?
  struct ip_mreq  mreq;
  setsockopt (socket, IPPROTO_IP, IP_MULTICAST_IF, &mreq, sizeof(mreq));
 

Best Regards
-----
Shan Wei
