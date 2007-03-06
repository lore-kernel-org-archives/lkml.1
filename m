Return-Path: <linux-kernel-owner+w=401wt.eu-S965859AbXCFL1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965859AbXCFL1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 06:27:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965862AbXCFL1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 06:27:13 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:48442 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965859AbXCFL1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 06:27:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=PXGoTu1MtaNOKblfWJrS2UMYLHioCeCQo3fYTbqt3RWFzbMIeoFrRKvPiiMGst8GBoa6g0gOgoil1/EU7bIExDZ6Qp5/A1AK4FkVxrTIxHb5Fl3Wq6OI9PImIeS1R5dBxdy2/QNnAGjOglSoP/SKvxvoTcLMvefXvsbv9OHl7GI=
Message-ID: <4c348ac20703060327t44450331la1be820bc146d308@mail.gmail.com>
Date: Tue, 6 Mar 2007 16:57:11 +0530
From: "Kanhu Rauta" <choiskanhu@gmail.com>
To: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Problem With LOCAL IN HOOK
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

I am writing a simple loadable module which will a register a function
in NF_IP_LOCAL_IN hook .But observed  different behavior in 2.4 and
2.6 kernel.

a> in 2.4 kernel, my function gets the assembled packet (in case of
fragmentation).

static struct nf_hook_ops test_forwarder
= { { NULL, NULL }, callback_forwarder, PF_INET, NF_IP_LOCAL_IN,
NF_IP_PRI_FILTER };

This is working fine .i got the assembled packet in function
callback_forwarder(in case of fragmentation).


b> in 2.6 kernel, my function gets the un-assembled packets (in case
of fragmentation).

static struct nf_hook_ops test_forwarder = {
  .hook     = callback_forwarder,
  .owner    = THIS_MODULE,
  .pf       = PF_INET,
  .hooknum  = NF_IP_LOCAL_IN,
  .priority = NF_IP_PRI_FILTER, };


This is not working, because i got the unassembled packet here. though
udp length shows 1508.but i am getting only 1400 bytes of valid data,
rest 108 bytes are something garbage.that i cross check with ethereal.
(I prints in a for loop like skb-data+20 to skb->data[1528])

I am not able to understand the behavior and struggled to resolve this
issue for last 1 week .

Can anybody help me on this regard ?



Regards,
kanhu
