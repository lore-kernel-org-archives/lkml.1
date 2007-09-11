Return-Path: <linux-kernel-owner+w=401wt.eu-S1761909AbXIKHpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761909AbXIKHpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 03:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757920AbXIKHpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 03:45:32 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:4847 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272AbXIKHpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 03:45:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ii8tu8e3iB3P6PrN2pep1pIT0lcO+3sveSTSiMtg5qkWVf/NUV6ZcOgZHMukHGkILEgNoNNRPwKY8A6ynOKM5Dk4/CoWILElPCgJ76nwwLqlLBxrW1PJ0u4rPJZ2lVldi+VFiO6NPeajrzLTOpj4BBlkBYW4dxxiBps+ts/Dgaw=
Message-ID: <8d33dcd40709110045v532e062ex7f05ac3ba9386161@mail.gmail.com>
Date: Tue, 11 Sep 2007 15:45:29 +0800
From: "Alvin Valera" <alvinvalera@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Socket owner problem?
In-Reply-To: <1189496159.849702.82190@50g2000hsm.googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1189496159.849702.82190@50g2000hsm.googlegroups.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am currently writing a kernel module that will apply some delay to
incoming packets. The module is implemented using netfilter hooked
into the NF_IP_LOCAL_IN. Once the module receives a packet of interest
from the lower layer, it will queue the packet (in it's own queue) and
associate a kernel timer. Once the kernel timer expires, the packet is
then propagated up the higher layer.

The problem happens like this:
Once the socket is closed by the user-space application, there are
still packets left in the module's queue. Now, the moment the kernel
timer expires and the module propagates those packets up into the
higher layer, the system hangs.

I've been searching for ways to determine if associated socket is
closed. This way, if my module knows that the user-space already
closed the socket, it will not propagate the packet up. Does anyone
have a solution for this problem?

Thanks!
