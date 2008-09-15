Return-Path: <linux-kernel-owner+w=401wt.eu-S1755826AbYIOTnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbYIOTnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 15:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYIOTnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 15:43:04 -0400
Received: from rn-out-0910.google.com ([64.233.170.187]:60855 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbYIOTnB (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 15:43:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BR+5/lyYptLaQtqYnd3gDPvbqdDc9GJsEbLwLPLOTibHJn9NJg56k/CYjFAeX87JCq
         4ljY+Kvgc5eUcmvMrR0RCp2RmexPOdUkn4uZzeW/6dnz3/xRm3PxW/QKRBJ6RH7/h4gh
         bkx1kNXEShhcpTuYYRuqD3XMn+UCXpO8qp26k=
Message-ID: <6934efce0809151243h60a6e48bpf0c7600d4badf3c4@mail.gmail.com>
Date: Mon, 15 Sep 2008 12:43:00 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Jamie Lokier" <jamie@shareable.org>
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Cc: "Greg Ungerer" <gerg@snapgear.com>, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <20080915163421.GA13631@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6934efce0809121452kd20deb6m268715f6ed83a71e@mail.gmail.com>
	 <20080915163421.GA13631@shareable.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> >> I'm using Spansion MirrorBit S29GL128N, which reads at about 0.6 MByte/s.
>>
>> If you are using a GL, you'll probably find our P33 a good fit and at
>> competitive prices to GL as I understand it.  That's I think 50Mhz.
>
> What's a GL?  Never heard of it - all I can think of is OpenGL :-)

S29_GL_128N

> I'm not sure if cache is an option with this device - but would it
> make a difference anyway?

Well the first read takes 100ns (plus the other chipset overhead
300ns) but other reads in a page are only an extra 25ns each.  So your
benefit is not from having the entire executable in cache it's from
having the next 7 instructions in the cacheline for only an extra 25ns
each instead of 400ns.

> Interesting, thanks.  I'm not sure it's possible to change the way NOR
> is being used with this chip, and it'll be a while before it's
> economical to replace the board with a new design.

Usually these things can be fixed in the bootloader or by hacking the
kernel to tweak the relevant chipset registers.
