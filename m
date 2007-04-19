Return-Path: <linux-kernel-owner+w=401wt.eu-S2993197AbXDSIIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993197AbXDSIIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 04:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993156AbXDSIIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 04:08:12 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:3117 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993190AbXDSIHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 04:07:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fVt2uXWZaGOCwcqsmgHeiCPn0BH2KpG2+/D6VXL35wHvNfjcxth0oi8O/UbhzLwtfP3qOcANGrmJXEN5F6XuVBWouKEFph+YkeNJmKBRlCRMW/xASWoHY5d3VKLj6YNILOgMR1B/crlbha+CNtT3MyDN/R0WL5+egJENfY+pXwg=
Message-ID: <38b2ab8a0704190107x2c151bafx824beca052f97ef6@mail.gmail.com>
Date: Thu, 19 Apr 2007 10:07:53 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: [CRYPTO] is it really optimized ?
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, helge.hafting@aitel.hist.no,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
In-Reply-To: <adalkgq3nx6.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0704170659o3f65f5fbo94a59be58727d21c@mail.gmail.com>
	 <E1HdoGm-0005WU-00@gondolin.me.apana.org.au>
	 <38b2ab8a0704170741n619e169s6a2f3ac5b768a950@mail.gmail.com>
	 <adairbv57s2.fsf@cisco.com>
	 <38b2ab8a0704170914h3a766236t47bc7e1c8de67662@mail.gmail.com>
	 <ada7isb3qr2.fsf@cisco.com>
	 <38b2ab8a0704171024m3d838bdak14370a7d0931557f@mail.gmail.com>
	 <adalkgq3nx6.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/17/07, Roland Dreier <rdreier@cisco.com> wrote:
>  > > It seems trivial to keep the last key you were given and do a quick
>  > > memcmp in your setkey method to see if it's different from the last
>  > > key you pushed to hardware, and set a flag if it is.  Then only do
>  > > your set_key() if you have a new key to pass to hardware.
>  > >
>  > > I'm assuming the expense is in the aes_write() calls, and you could
>  > > avoid them if you know you're not writing something new.
>
>  > that's a wrong assumption. aes_write()/aes_read() are both used to
>  > access to the controller and are slow (no cache involved).
>
> Sorry, I wasn't clear.  I meant that the hardware access is what is
> slow, and that anything you do on the CPU is relatively cheap compared
> to that.
>
> So my suggestion is just to keep a cache (in CPU memory) of what you
> have already loaded into the HW, and before reloading the HW just
> check the cache and don't do the actual HW access if you're not going
> to change the HW contents.  So you avoid any extra aes_write and
> aes_read calls in the cache hit case.
>
> This would have the advantage of making anything that does lots of
> bulk encryption fast without special casing ecryptfs.
>

I'm not sure how "memcmp(key, cache, KEY_SIZE)" would impact AES
performance. I need to give it a test but can't today. I'll do
tomorrow and give you back the result.

Thanks
-- 
Francis
