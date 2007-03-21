Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbXCUX22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbXCUX22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbXCUX22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:28:28 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:64130 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbXCUX21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:28:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ZNICp8HuMzoG5km/cddBdOiWS7lO0eTudksvlxdnqiOHSzah2fk9Wmv/QsImdQEwLAgqAZiGEFudIj1GQNvenDs5WAqeyFitkFZvP5EGoZhpuCQBX0tbhlIO4QnzgbxHp1uRjDpeAJfS2Yu2Hf28S3lNKzIDkuvHfdGyELHDK40=
From: Maxim <maximlevitsky@gmail.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [RFC] : Is /proc/kcore still usefull and/or maintained ?
Date: Thu, 22 Mar 2007 01:28:18 +0200
User-Agent: KMail/1.9.6
Cc: Eric Dumazet <dada1@cosmosbay.com>, Andi Kleen <ak@suse.de>,
       David Howells <dhowells@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
References: <200703211840.53242.maximlevitsky@gmail.com> <4601B89E.3060605@cosmosbay.com> <Pine.LNX.4.61.0703220011080.9555@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0703220011080.9555@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703220128.18610.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 March 2007 01:11:57 Jan Engelhardt wrote:
> 
> On Mar 21 2007 23:58, Eric Dumazet wrote:
> > Hi all
> >
> > On i386 , 2.6.20 / 2.6.21-rc4 :
> >
> > # gdb vmlinux /proc/kcore
> > error
> > # file /proc/kcore
> > error
> 
> 00:11 ichi:/hld # file /proc/kcore
> /proc/kcore: ELF 32-bit LSB core file Intel 80386, version 1 (SYSV),
> SVR4-style, from 'vmlinux'
> 00:11 ichi:/hld # hexdump -C /proc/kcore | head -n5
> 00000000  7f 45 4c 46 01 01 01 00  00 00 00 00 00 00 00 00  |.ELF............|
> 00000010  04 00 03 00 01 00 00 00  00 00 00 00 34 00 00 00  |............4...|
> 00000020  00 00 00 00 00 00 00 00  34 00 20 00 03 00 00 00  |........4. .....|
> 00000030  00 00 00 00 04 00 00 00  94 00 00 00 00 00 00 00  |................|
> 00000040  00 00 00 00 a8 06 00 00  00 00 00 00 00 00 00 00  |................|
> 00:11 ichi:/hld # uname -rm
> 2.6.20.2 i686
> 
> >
> >
> > Apparently we can not llseek() anymore on this file (returns -EINVAL)
> >
> > On x86_64 2.6.20 it's working
> >
> > # file /proc/kcore
> > /proc/kcore: ELF 64-bit LSB core file x86-64, version 1 (SYSV), SVR4-style
> >
> >
> > On i386 2.6.14 it's working too.
> >
> > Eric
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> >
> 
> Jan

Hello, 

	I once had similar problem with /proc/kcore

	then gdb showed all zeros for all kernel memory,

	I had look at code , and I found that "Sparse memory model" was the problem, it doesn't say where kernel memory is 
	(I don't remember details now)
	I once choosed it just for experiment,  so I switched to Flat memory, and /proc/kcore works fine till then,

	I use 32 bit x86 kernel.

	Regards,
		Maxim Levitsky
