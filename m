Return-Path: <linux-kernel-owner+w=401wt.eu-S1757844AbYF0IiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844AbYF0IiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 04:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755474AbYF0IiC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 04:38:02 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:59867 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408AbYF0IiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 04:38:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=WrVjkoOgj0TM040w5LHbnsu5suxNeTPQE8JN0q2fKPh7caMT7P0I/uhcI19QqTwV7C
         9XZF1EBk1EHImGo+dQGfVhfKjel/nfesmeQEQEVsRtqwUNVooIXi1HR5J8T9ehkIpMnt
         BlrKmRNLNeyoQ273ZnlB0QWHQ23lRpE+X5t0M=
Message-ID: <965f530d0806270137y19c36638yc6ae0a1d4bfa63e7@mail.gmail.com>
Date: Fri, 27 Jun 2008 03:37:59 -0500
From: "Kiran Kotla" <kotlakiran@gmail.com>
To: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: setting ICSK_CA_PRIV_SIZE larger than 16 * sizeof(u32)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

We have a recently implemented our Congestion control algorithm named
PERT (Probabilistic early response TCP), in the linux kernel.

As a part of it, we needed to define some variables in the private
variables part ( __u32 icsk_ca_priv[16] ) of per flow structure
(struct inet_connection_sock) in the file
"include/net/inet_connection_sock.h"

As you can see the limit on the number of private variables has been
imposed to 16 u32 variables. However, our protocol requires that we
have more than 16 say upto 25 u32 variables.
We tried changing the size of icsk_ca_priv from 16 to a larger value
and correspondingly changed the #define  ICSK_CA_PRIV_SIZE to a larger
value which was initially set to  "16 * sizeof(u32)".

We have searched the entire kernel code but did not find any other
dependency on the size of "icsk_ca_priv". We compiled the code and
rebooted the machine with the new image and we see a kernel crash
(Panic) at the very piece of code where this structure is being
initialized. We reset it back to 16 and it worked perfectly fine.

I just wanted to ask if there is a way to change the size of this
private variable array "icsk_ca_priv".

The only other option we have to get the kernel running with our
protocol is to reduce the number of private variables and this is not
possible without affecting the behavior of our protocol.

It would be great if someone of you who have used this structure
sometime shedded light on this.

Your replies are very well appreciated.

Thanks a ton in advance.

best wishes
Kiran Kotla
