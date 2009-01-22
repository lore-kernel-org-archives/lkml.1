Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbZAVTEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbZAVTEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 14:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754934AbZAVTEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 14:04:43 -0500
Received: from marvin.heresymail.org ([87.106.62.5]:33729 "EHLO
	marvin.heresymail.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbZAVTEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 14:04:43 -0500
Message-ID: <4978C346.9070504@walrond.org>
Date: Thu, 22 Jan 2009 19:04:38 +0000
From: Andrew Walrond <andrew@walrond.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28 headers break kbd and net-tools userspace builds
References: <49786A59.6040706@walrond.org> <20090122175645.GA14178@uranus.ravnborg.org>
In-Reply-To: <20090122175645.GA14178@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>
> I checked the include guards and they are correct.
>
> Could you please investige where it picks up the first definition
> of struct iphdr.
>
>   
Here you go:

$ make iptunnel.o

cc -D_GNU_SOURCE -O2 -Wall -g  -I. -idirafter ./include/ -Ilib   -c -o
iptunnel.o iptunnel.c
In file included from /usr/include/linux/if_tunnel.h:5,
                 from iptunnel.c:39:
/usr/include/linux/ip.h:85: error: redefinition of 'struct iphdr'

$ grep -r iphdr /usr/include/

/usr/include/netinet/ip.h:struct iphdr
/usr/include/netinet/tcp.h: * This should be defined as MIN(512, IP_MSS
- sizeof (struct tcpiphdr)).
/usr/include/linux/if_tunnel.h:    struct iphdr        iph;
/usr/include/linux/ip.h:struct iphdr {

$ grep netinet/ip.h iptunnel.c

#include <netinet/ip.h>

So linux/ip.h is clashing with glibc(2.8)'s netinet/ip.h

Andrew Walrond

