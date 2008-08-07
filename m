Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbYHGDe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbYHGDe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 23:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbYHGDer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 23:34:47 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:27256 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753310AbYHGDeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 23:34:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=HslJbfwLUa5wTAzKYo7zMT2CEbdtA+qJsO+K0XtIcA0Cn/Hy0RoNj8IyV8t/5jglQozcLRV+Av7FmkxAEFLGzMxT/sVRetF9xRQoFEODtnBK9qlPO/nhvyf2EyfiNEq4qUN3sySDzYD97eF+Spg0tdVtVLmkje+PqzEtP0vGA/A=  ;
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: [PATCH RFC] USB: Add HCD fastboot
Date: Wed, 6 Aug 2008 20:34:43 -0700
User-Agent: KMail/1.9.9
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Daniel Walker <dwalker@mvista.com>,
       USB list <linux-usb@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <Pine.LNX.4.44L0.0807311510220.5019-100000@iolanthe.rowland.org> <4899F035.9040003@simon.arlott.org.uk>
In-Reply-To: <4899F035.9040003@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200808062034.43899.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 August 2008, Simon Arlott wrote:
> +ifndef CONFIG_USB_FASTBOOT
> +  obj-y                                += $(tmp-y)
> +endif
>  
>  obj-$(CONFIG_USB_ACM)          += class/
>  obj-$(CONFIG_USB_PRINTER)      += class/
> @@ -34,3 +40,7 @@ obj-$(CONFIG_USB)             += misc/
>  
>  obj-$(CONFIG_USB_ATM)          += atm/
>  obj-$(CONFIG_USB_SPEEDTOUCH)   += atm/
> +
> +ifdef CONFIG_USB_FASTBOOT
> +  obj-y                                += $(tmp-y)
> +endif

If you want to do such stuff, don't be conditional.
Just change it so USB is *always* earlier.

We really don't need to make boot sequences become
even harder to understand/predict.

