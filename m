Return-Path: <linux-kernel-owner+w=401wt.eu-S1759581AbZGICg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581AbZGICg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 22:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758989AbZGICgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 22:36:52 -0400
Received: from mail-pz0-f175.google.com ([209.85.222.175]:57844 "EHLO
	mail-pz0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758638AbZGICgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 22:36:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iP1iOrJ8UAWCV/lXqVRG6hULPJ/bXYi8ENBEaVxPVOwZlvgEeXzOI9g1XyPxOB50t4
         Ibd7YPArDQ9pUYeeaeSo0IyrLYYVlXagLucLOZXZOq9vz16voRvbMU1/kyYfEtWHuQEB
         8Q+5dDzUS6ldwh1eVwt+dTVIWtdOt71HD+kKk=
Date: Thu, 9 Jul 2009 10:38:55 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Dick Streefland <dick@streefland.net>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: simplification of scripts/extract-ikconfig
Message-ID: <20090709023855.GA5648@cr0.nay.redhat.com>
References: <20090623225245.GA10443@streefland.net> <20090624021506.GA5871@cr0.nay.redhat.com> <20090624114607.GA10817@streefland.net> <20090624133148.GA12878@streefland.net> <20090629025146.GA5998@cr0.nay.redhat.com> <20090629113613.GA6853@streefland.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629113613.GA6853@streefland.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 01:36:13PM +0200, Dick Streefland wrote:
>On Monday 2009-06-29 10:51, Amerigo Wang wrote:
>| Does this work?
>| My quick test shows no...
>| 
>| I still can't get the right offset number with this trick.
>| 
>| P.S. My grep is 2.5.1.
>
>I've tested the script with grep 2.5.1, and it works for me. Can you be
>more specific about what you think is wrong with the offsets? You need
>to be aware of the fact that because "tr" replaces the first character
>of the pattern by a newline, an offset will be 1 higher than the start
>of the original pattern. The resulting offsets are therefore 1-based
>instead of 0-based, which is exactly what "tail" expects for the "-c"
>option.

Hi,

I appologize for my delay, I totally missed this thread, sorry.

I just tested it, it works! So,

Tested-by: WANG Cong <xiyou.wangcong@gmail.com>


But, I still don't understand the behavior of 'grep -abo',
please try the following commands:

echo -e '\x01\x02\x03\x04' > test.bin
od -x test.bin
tr $'\x01\x02\x03\x04' '1234' < test.bin | grep -abo '4'


Am I missing something here??

Thanks.
