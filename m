Return-Path: <linux-kernel-owner+w=401wt.eu-S1422952AbXBHMPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422952AbXBHMPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 07:15:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422946AbXBHMPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 07:15:16 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:34843 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422952AbXBHMPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 07:15:15 -0500
Date: Thu, 8 Feb 2007 13:14:57 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Jack Bauer <mlsubscriber@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [QUESTION] Kernelspace <-> Userspace communication during tcp
 stack code execution
In-Reply-To: <619420780702070834n6dec9871keb87bf913a2ca5@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0702081311440.1364@yvahk01.tjqt.qr>
References: <619420780702070834n6dec9871keb87bf913a2ca5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 7 2007 17:34, Jack Bauer wrote:
>
> As you might imagine I have to alter the syn,synack and ack packets
> and fill it with authentification information of the user who
> initiated the new TCP connection. These information are stored in
> config files on the client/user host (for example a config file which
> contains the location of the users certificate). On the firewall host
> I also need file access from within a netfilter kernel module and have
> to perform other time consuming tasks (for example reading the root
> certificate and check the users cert in the syn packet).
>
> As these tasks are typical userspace tasks I want to write a daemon
> which does all the file access and certificate work when the kernel
> requests it and which than sends the information back to the kernel.
>
> What opportunities do I have to implement a fast Kernel <-> Userspace
> Daemon communication?

The netfilter QUEUE target is *exactly* what you are looking for. Have
some iptables rules that divert the first two incoming packets (SYN only
and the ACK only) to your userspace daemon (which is at the other end of
ipt_QUEUE) have it do whatever is needed.


Jan
-- 
ft: http://freshmeat.net/p/chaostables/
