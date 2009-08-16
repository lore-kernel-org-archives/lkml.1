Return-Path: <linux-kernel-owner+w=401wt.eu-S1752103AbZHPNtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbZHPNtg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 09:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZHPNtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 09:49:35 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:61120 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZHPNtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 09:49:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VDeOhWWFsZfzsxQeguqpoc7v2Zz0fmv5+geBnUXzEt2oaT0RRjE23mYNAu9FCvyTU9
         lDhd86hVi8whEo/Oxwi/vQQBDribo6eFSmom2wgOPU0xxyZX+KyNxe2u/uk6qZARAqCL
         6eomJ9tq1otDssNPCPBzAfWyAaP9yia/zJ2c4=
MIME-Version: 1.0
In-Reply-To: <4A87FCAC.5070705@gmail.com>
References: <1250002683-28554-1-git-send-email-mspang@csclub.uwaterloo.ca>
	 <4A87FCAC.5070705@gmail.com>
Date: Sun, 16 Aug 2009 09:42:49 -0400
X-Google-Sender-Auth: de9e534d7e0166d4
Message-ID: <118a63b80908160642j73568637n2f3fa97fc33d8e57@mail.gmail.com>
Subject: Re: [PATCH] Revert netlink ABI change to gnet_stats_basic
From: Michael Spang <mspang@csclub.uwaterloo.ca>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 16, 2009 at 8:33 AM, Eric Dumazet<eric.dumazet@gmail.com> wrote:
>
> What exactly broke after patch was pushed ?

The libnl library refuses to initialize with 2.6.30 with pre-2.6.30
headers. With 2.6.30 I get

  $ libnl-1.1/src/nl-qdisc-dump brief
  Unable to retrieve qdisc cache

whereas previously I would get

  $ libnl-1.1/src/nl-qdisc-dump brief
  htb qdisc dev eth0 handle 01: parent root r2q 10000 default :02

It works fine if I use the headers from 2.6.30, but then I don't
believe it would work with older kernels.

Michael
