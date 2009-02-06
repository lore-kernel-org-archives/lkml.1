Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbZBFT26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbZBFT26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 14:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbZBFT2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 14:28:49 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:20645 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbZBFT2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 14:28:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DRlAZULbqNUJSZTsgqt0+cKBlBgAOHwHwCRq60k/JeUujvL7HdUW719M5HQqoq1KPO
         UKpb4QQU8vjH/zh07Ykq6C+4afPIeZGEh3WKlyWWKqXp6sGAk/CKE+Ijh++gkkQtIfE8
         C1p574hNYBc0m9P7HJs7B50oucDJiF77nOYNU=
MIME-Version: 1.0
In-Reply-To: <20090206192629.GE10711@frodo>
References: <1233915736-18506-1-git-send-email-cooloney@kernel.org>
	 <20090206191558.GD10711@frodo>
	 <8bd0f97a0902061124s3c44d39dmf306a44f0c16528d@mail.gmail.com>
	 <20090206192629.GE10711@frodo>
Date: Fri, 6 Feb 2009 14:28:46 -0500
Message-ID: <8bd0f97a0902061128r70cecec3p4c927f2daa38d517@mail.gmail.com>
Subject: Re: [PATCH] usb: musb: tweak musb_read_fifo() to avoid unused 
	warnings
From: Mike Frysinger <vapier.adi@gmail.com>
To: me@felipebalbi.com
Cc: Bryan Wu <cooloney@kernel.org>, felipe.balbi@nokia.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 6, 2009 at 14:26, Felipe Balbi wrote:
> On Fri, Feb 06, 2009 at 02:24:27PM -0500, Mike Frysinger wrote:
>> On Fri, Feb 6, 2009 at 14:15, Felipe Balbi wrote:
>> > On Fri, Feb 06, 2009 at 06:22:16PM +0800, Bryan Wu wrote:
>> >> From: Mike Frysinger <vapier.adi@gmail.com>
>> >
>> > I'd like to get a patch body here.
>> >
>> >> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
>> >> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>> >> ---
>> >>  drivers/usb/musb/blackfin.c |    9 +++++----
>> >>  1 files changed, 5 insertions(+), 4 deletions(-)
>> >>
>> >> diff --git a/drivers/usb/musb/blackfin.c b/drivers/usb/musb/blackfin.c
>> >> index 7861348..0ebb19d 100644
>> >> --- a/drivers/usb/musb/blackfin.c
>> >> +++ b/drivers/usb/musb/blackfin.c
>> >> @@ -54,13 +54,11 @@ void musb_write_fifo(struct musb_hw_ep *hw_ep, u16 len, const u8 *src)
>> >>  void musb_read_fifo(struct musb_hw_ep *hw_ep, u16 len, u8 *dst)
>> >>  {
>> >>       void __iomem *fifo = hw_ep->fifo;
>> >> +
>> >> +#ifdef CONFIG_BF52x
>> >>       u8 epnum = hw_ep->epnum;
>> >>       u16 dma_reg = 0;
>> >
>> > Is this patch avoiding a warning about these variables being unused ?
>> >
>> > Would be nice to get this info to the patch body ;-)
>>
>> the subject already says that
>
> the subject says:
>
> "tweak musb_read_fifo() to avoid unused warnings"
>
> it doesn't specify where are the warnings.

i dont think it really adds anything to explicitly mention every
variable that triggers an unused warning.  but if we look at the code
that changed, it's easy to see that it's epnum and dma_reg.
-mike
