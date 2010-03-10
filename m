Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab0CJJTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 04:19:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab0CJJTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 04:19:47 -0500
Message-ID: <4B976503.4050702@redhat.com>
Date: Wed, 10 Mar 2010 17:23:15 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: David Miller <davem@davemloft.net>, opurdila@ixiacom.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       nhorman@tuxdriver.com, eric.dumazet@gmail.com
Subject: Re: [net-next PATCH v6 0/3] net: reserve ports for applications using
 fixed port numbers
References: <1267233952-5856-1-git-send-email-opurdila@ixiacom.com>	<20100227.033230.196838696.davem@davemloft.net>	<4B8F6FF0.5000306@redhat.com> <m1vddbdhmo.fsf@fess.ebiederm.org>
In-Reply-To: <m1vddbdhmo.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> I would add the restriction that the values in the list of ranges
> always must be increasing, and in general restrict the set of accepted
> values as much as possible.  If we don't accept it now we don't have
> to worry about some userspace application relying on some unitended
> side effect a few years into the future.

I don't think this is good.

Suppose that when I just want to add one port into the list and keep the
original ones, I want to do this:

orig=$(cat ip_local_reserved_ports)
new_list="$orig, $new_one"
echo "$new_list" > ip_local_reserved_ports

If we add this restriction, the above could be failed if the new port
is lower than the original ones. This will be not convenient.

> 
> 
> I think it is a serious bug that you clear the destination bitmap
> in the middle of parsing it.  That will either open or close all
> ports in the middle of parsing, and I can't see how that would
> ever be a good thing.
> 

Agreed.

By the way, Octavian, any new updates?
