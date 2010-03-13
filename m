Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933721Ab0CMLXG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 06:23:06 -0500
Received: from mail-qy0-f179.google.com ([209.85.221.179]:56908 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759012Ab0CMLXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 06:23:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=RrFttUOrKQDtr4YbkKEc/gTKVjxf9u7RUCzll5ArF+x30qZ2d+MlCT/KySI+ocnlNb
         S1LRXmgS1jTsNiPW3hVwkQFyfO2NfRHTkRoLHCRftkQv09wLqtfIy7KghFEmqhv4HEkm
         EdW7NBpRPntzuf+afQwKT+Ta6Jg8V5uEBC3Ts=
Message-ID: <4B9B7591.9080706@gmail.com>
Date: Sat, 13 Mar 2010 06:22:57 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
CC: Eric Dumazet <eric.dumazet@gmail.com>, Dan Carpenter <error27@gmail.com>,
       David Miller <davem@davemloft.net>, Simon Horman <horms@verge.net.au>
Subject: Code paths setting gso_size
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a new thread dedicated to a specific topic, spawned by an
earlier discussion.  I've CC'd only those that participated recently.

I've written:
# In this particular instance, I suggest that you take a look at all the
# places that gso_size is set, and cross index with all the code paths that
# place these TCP headers onto the txq without a check of doff -- as I did!
#
# I'll specifically mention the tun and virtio_net devices, but I'm also
# particularly concerned with af_packet.c and skbuff.c -- and the general
# problem with inet_lro.c, too.
#
# Amazingly enough, folks sometimes use Linux for routers....
#

Eric (and David) have written:
# Only *locally* generated trafic by linux kernel can enter this path.
#

So, let us begin with the tun device, and work our way through the others.

