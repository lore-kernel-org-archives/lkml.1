Return-Path: <linux-kernel-owner+w=401wt.eu-S1753337AbYIPVoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbYIPVoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 17:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYIPVnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 17:43:52 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:60662 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYIPVnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 17:43:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Z1Fq7Amdipelm5TN6LC4APWgE3GFnrT5CTHgbPRJWzHo9W7T/4jyxxJr5hspBz+QJX
         VXiuegJ7otEPSWWQ5fJxvPfDB3Ercxj8izdl5narXKLVfF7fRMGRMDm5fqJhJ6v3Y/JY
         y1/RoOT46IcwkKCReiLGDZonxm0yeCfYmyN9A=
Message-ID: <b647ffbd0809161443o5b7bf71aw59853d8d6086ee2d@mail.gmail.com>
Date: Tue, 16 Sep 2008 23:43:50 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [x86-tip, patch] rework of the microcode splitup
Cc: "Peter Oruba" <peter.oruba@amd.com>,
       "Tigran Aivazian" <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080914125513.GA22281@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221383648.6184.28.camel@earth> <20080914125513.GA22281@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/14 Ingo Molnar <mingo@elte.hu>:
>
> * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
>
>> Ingo, Peter,
>>
>>
>> this version is slightly different from the current one in -tip (added
>> missing vfree()).
>
> i've added the delta patch below. I removed the #if 0's as they are
> ugly. (and editing the file to enable debug printouts is easy anyway)

ok, thanks.

>
> regarding this FIXME:
>
> +       /* FIXME! dimm: Why not by means of get_totalsize(hdr)? */
>        total_size = (unsigned long) (hdr[4] + (hdr[5] << 8));
>
> please just use get_totalsize(hdr) and get rid of the fixme that way :)

The thing is that it looks like there are 2 headers that contain the size.
'hdr' taken by get_totalsize() is not the same as 'hdr' from which
total_size is calculated here. :^)

A quick search didn't reveal any docs describing the AMD microcode
file format, so I'd rather leave it up to Peter.


>
>        Ingo
>

-- 
Best regards,
Dmitry Adamushko
