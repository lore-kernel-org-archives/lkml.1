Return-Path: <linux-kernel-owner+w=401wt.eu-S935825AbXGRSHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935825AbXGRSHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759495AbXGRSHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:07:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:19833 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbXGRSHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:07:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FW9FnbYf9sUeS8a+42j9st03UWKIJjuK2/E36Pr2vESXBAmPDDHrxRZBI5CjVvw0NsjFIdNdP+3UP4MI0gClDMvHwGZX5DOu5fuWgyryZKSyU714AMs0RXcKCPpk8jf7godvZ1HMG429Jz19kZDTMai+dD4kxH4H3u06zEQeP5A=
Message-ID: <64d833020707181107o705ff16ava129e91fcf68a8ef@mail.gmail.com>
Date: Wed, 18 Jul 2007 14:07:36 -0400
From: koan <koan00@gmail.com>
To: "Rui Santos" <rsantos@grupopie.com>
Subject: Re: Slow Soft-RAID 5 performance
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <469E4A70.1000306@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64d833020707180707i1bbbbcbao783e33a2487c9e2b@mail.gmail.com>
	 <469E4A70.1000306@grupopie.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Are you sure about that chunk size? In you initial posting you show
/proc/mdstat reporting:

"md2 : active raid5 sdc3[2] sda3[0] sdb3[1]
      780083968 blocks level 5, 128k chunk, algorithm 2 [3/3] [UUU]"

Which would seem to state a 128K chunk, and thus with a 4k block size
you would need a stride of 32.



On 7/18/07, Rui Santos <rsantos@grupopie.com> wrote:
> koan wrote:
> > How did you create the ext3 filesystem?
>
> The chunk_size is at 256KB, ext3 block size is 4k. I believe the correct
> option that should be passed trough to --stride is 64.
> Am I correct ?
>
> I've also tested ( after sending my first report ) with xfs.
> I've also increases readahead to 65535 on all HD's
> I've also increases the stripe_cache_size to 16384.
>
> I can now get ~100MB/sec...
>
> >
> > Did you use the appropriate --stride option as noted here:
> > http://tldp.org/HOWTO/Software-RAID-HOWTO-5.html (#5.11)
> > -
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> >
> >
>
>
