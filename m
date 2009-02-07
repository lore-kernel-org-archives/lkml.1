Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbZBGEaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbZBGEaO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 23:30:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbZBGE36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 23:29:58 -0500
Received: from rn-out-0910.google.com ([64.233.170.191]:8277 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbZBGE35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 23:29:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ol4gLdAtb9HujfrkMyWBdlPugk4ObfvetKznkFP07fIwHBjuGfPFE0ocSLIHYjrnDP
         5KHk32KlUWlh9yaNMKJF/zeP5H+tyCx3s1v+omjlAd+dAvuFocF1/pPJZPZB87QWXt83
         HNG5Fg98tLiRKYZP+qrom6RtI4DLNsSkXrIUY=
MIME-Version: 1.0
In-Reply-To: <20090207000148.GF31059@kroah.com>
References: <1233915736-18506-1-git-send-email-cooloney@kernel.org>
	 <20090207000148.GF31059@kroah.com>
Date: Fri, 6 Feb 2009 23:29:54 -0500
Message-ID: <8bd0f97a0902062029l7cfd58d2ga0c12f2c33cc9d93@mail.gmail.com>
Subject: Re: [PATCH] usb: musb: tweak musb_read_fifo() to avoid unused 
	warnings
From: Mike Frysinger <vapier.adi@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Bryan Wu <cooloney@kernel.org>, felipe.balbi@nokia.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 6, 2009 at 19:01, Greg KH wrote:
> On Fri, Feb 06, 2009 at 06:22:16PM +0800, Bryan Wu wrote:
>> From: Mike Frysinger <vapier.adi@gmail.com>
>>
>> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>> ---
>>  drivers/usb/musb/blackfin.c |    9 +++++----
>>  1 files changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/usb/musb/blackfin.c b/drivers/usb/musb/blackfin.c
>> index 7861348..0ebb19d 100644
>> --- a/drivers/usb/musb/blackfin.c
>> +++ b/drivers/usb/musb/blackfin.c
>> @@ -54,13 +54,11 @@ void musb_write_fifo(struct musb_hw_ep *hw_ep, u16 len, const u8 *src)
>>  void musb_read_fifo(struct musb_hw_ep *hw_ep, u16 len, u8 *dst)
>>  {
>>       void __iomem *fifo = hw_ep->fifo;
>> +
>> +#ifdef CONFIG_BF52x
>
> Any way we can just not have ifdefs in .c files alltogether?

the sub arch.c files for musb are pretty much header files.  the
alternative (splitting up the funcs into their own header files) would
be much more bothersome for us to maintain atm i think since there's
so very little different.
-mike
