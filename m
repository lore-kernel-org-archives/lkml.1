Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690AbYJTQd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbYJTQd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 12:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYJTQdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 12:33:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:19045 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbYJTQda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 12:33:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gpmVKtg8dsPBfB3NY/k4i2LHT9uG0Tss3z1C/6Vhr7fOlbTJK+fNEkM+lGSFyLjA/G
         92eo0+LbXSFMwn9zEZdJsNc0i78YNrSlkICbtVm87p/H5VhKu4kEanJPdjKObv8PvUIE
         07Qo2agQ98Q9O52wsVMWooOCaLDMhjbagqkMs=
Message-ID: <3aaafc130810200933s7299378eg6924089a58b9778a@mail.gmail.com>
Date: Mon, 20 Oct 2008 12:33:29 -0400
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: linux-next: build failure
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       "Christopher Harrer" <charrer@alacritech.com>,
       "Michael Miles" <mmiles@alacritech.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, linus@kroah.com
In-Reply-To: <20081020154857.GC24666@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081020230420.aa85f83b.sfr@canb.auug.org.au>
	 <20081020154857.GC24666@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 11:48 AM, Greg KH <greg@kroah.com> wrote:
> On Mon, Oct 20, 2008 at 11:04:20PM +1100, Stephen Rothwell wrote:
>> Hi Greg,
>>
>> Today's linux-next build (powerpc allyesconfig) failed like this:
>>
>> In file included from drivers/staging/sxg/sxg.c:77:
>> drivers/staging/sxg/sxghif.h:859: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'Compilation'
>> drivers/staging/sxg/sxg.c: In function 'sxg_transmit_packet':
>> drivers/staging/sxg/sxg.c:1949: error: 'SXG_SGL_BUF_SIZE' undeclared (first use in this function)
>> drivers/staging/sxg/sxg.c:1958: error: implicit declaration of function 'SXG_SGL_BUFFER'
>> drivers/staging/sxg/sxg.c:1958: warning: assignment makes pointer from integer without a cast
>> drivers/staging/sxg/sxg.c: In function 'sxg_mcast_set_mask':
>> drivers/staging/sxg/sxg.c:2846: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'u64'
>>
>> I applied the following patch.
>
> Ah, doh, sorry, I should have caught that.  I'll go apply this to the
> tree, thanks.

Greg,

The slicoss driver also from Alacritech looks like it needs a depends
on X86 as well. Should the sxg and slicoss drivers from Alacritech be
doing things like this (sxg/sxghif.h:851, slicoss/slicoss.c:960):

#if defined(CONFIG_X86_64)

...

#else
    Stop Compilation;
#endif


>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
