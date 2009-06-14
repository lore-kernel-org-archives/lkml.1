Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbZFNHAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbZFNHAS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 03:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbZFNHAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 03:00:07 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:49570 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbZFNHAG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 03:00:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VKdGFVPELtxAKUG+g/dS/HuIqNdf6gECOD+T820wkSBdaFWoip3B43f0Zyvsihf/v0
         xW0VZjRpwxjHKL6nHLfNh8snS79ZtCyw3+hK+Yh4BNOfDcNXM546TIm4juyTzeR3HE4T
         cCTEQx99h+GlP07nmFTsXehlS32axrj7cuO0I=
MIME-Version: 1.0
In-Reply-To: <20090614.153046.25768784.konishi.ryusuke@gmail.com>
References: <20090614013211.GA22552@homero.springfield.home>
	 <20090614015240.GW30412@blitiri.com.ar>
	 <20090614.153046.25768784.konishi.ryusuke@gmail.com>
Date: Sun, 14 Jun 2009 10:00:06 +0300
X-Google-Sender-Auth: 091433b8c1377fe9
Message-ID: <84144f020906140000v7b38f520rc5d9849b8ea8ad7e@mail.gmail.com>
Subject: Re: NILFS2 get stuck after bio_alloc() fail
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: albertito@blitiri.com.ar, llucax@gmail.com, linux-kernel@vger.kernel.org,
       users@nilfs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 9:30 AM, Ryusuke
Konishi<konishi.ryusuke@lab.ntt.co.jp> wrote:
> The original GFP flag was GFP_NOIO, but replaced to GFP_NOWAIT at a
> preliminary release in February 2008.  It was because a user
> experienced system memory shortage by the bio_alloc() call.
>
> Even though nilfs_alloc_seg_bio() repeatedly calls bio_alloc()
> reducing the number of bio vectors in case of failure, this fallback
> did not work well.
>
> I'm in two minds whether I should change it back to GFP_NOIO.
> Or should I switch the gfp as follows?

As far as I can tell, the only difference with GFP_NOIO and GFP_NOWAIT
here is that the former will trigger the mempool_alloc() page reclaim
path. But I am not sure I understand why switching to GFP_NOWAIT
helped with memory shortage. What exactly was the problem there?

                                 Pekka
