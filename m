Return-Path: <linux-kernel-owner+w=401wt.eu-S1758823AbZIQJUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbZIQJUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 05:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758565AbZIQJUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 05:20:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758428AbZIQJUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 05:20:12 -0400
Message-ID: <4AB1FF14.6000801@redhat.com>
Date: Thu, 17 Sep 2009 17:19:16 +0800
From: Danny Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Shan Wei <shanwei@cn.fujitsu.com>
CC: davem@davemloft.net, kaber@trash.net, yoshfuji@linux-ipv6.org,
       jmorris@namei.org, pekkas@netcore.fi, kuznet@ms2.inr.ac.ru,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marc Milgram <mmilgram@redhat.com>
Subject: Re: [PATCH 2/2] ipv4: make do_ip_setsockopt for IP_MULTICAST_IF support
 ip_mreq struct
References: <1253164811-15820-1-git-send-email-dfeng@redhat.com> <4AB1FE6E.9000201@cn.fujitsu.com>
In-Reply-To: <4AB1FE6E.9000201@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2009 05:16 PM, Shan Wei wrote:
> Xiaotian Feng wrote, at 09/17/2009 01:20 PM:
>> ip_mreq and ip_mreqn is almost the same, and do_ip_setsockopt for IP_MULTICAST_IF
>> part supported ip_mreqn struct. This patch adds support for ip_mreq struct.
>>
>
> It's not meaning to support the ip_mreq struct, the imr_multiaddr member
> never be used by the IP_MULTICAST_IF.
>
> In addition, using the option normally like this:
>    struct in_addr interface_addr;
>    setsockopt (socket, IPPROTO_IP, IP_MULTICAST_IF,&interface_addr, sizeof(interface_addr));
>
> Do your patch suggest using the option like this?
>    struct ip_mreq  mreq;
>    setsockopt (socket, IPPROTO_IP, IP_MULTICAST_IF,&mreq, sizeof(mreq));
>
In fact, current implemetation supports:

struct ip_mreqn mreqn;
setsockopt(socket, IPPROTO_IP, IP_MULTICAST_IF, &mreqn, sizeof(mreqn));

Then why not support mreq?
>
> Best Regards
> -----
> Shan Wei
>

