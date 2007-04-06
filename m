Return-Path: <linux-kernel-owner+w=401wt.eu-S932564AbXDFT6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbXDFT6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932516AbXDFT6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:58:07 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:44721 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406AbXDFT6D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:58:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ClbTv+tc37zKL40C2eOFl6f4MTw3IHZhCzbdFp3LzVQ2RqMG9mbMIru79vx/Vbl6GJkQWX+KzuEdyQfKK+YgItu48eSgMxQhtOBc6yf93MSwRS2mLbl7tlnMVGOwWqfRqlPbF4tXiXEDBrLtKrC5zsRRI9np11uAav9ozWOgHH0=
Message-ID: <d9def9db0704061258v47d4cf5dwaac39625e8d00150@mail.gmail.com>
Date: Fri, 6 Apr 2007 21:58:02 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Oliver Neukum" <oneukum@suse.de>
Subject: Re: kernel OOPSes when changing DVB-T adapter in 2.6.21-rc3
Cc: CIJOML <cijoml@volny.cz>, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200703161025.44681.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <200703091641.54249.cijoml@volny.cz>
	 <200703151502.32161.oneukum@suse.de>
	 <200703161013.37312.cijoml@volny.cz>
	 <200703161025.44681.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I committed a patch which fixes this issue:

http://mcentral.de/hg/~mrec/v4l-dvb-stable/

That problem got caused by releasing data structures which are still
in use when the device gets unplugged. These patches delay the
deallocation of the data till the last user releases its reference to
the dvb nodes.

This patch got tested with devices which use the dvb-usb framework as
well as em28xx based dvb devices.

Markus

On 3/16/07, Oliver Neukum <oneukum@suse.de> wrote:
> Am Freitag, 16. März 2007 10:13 schrieb CIJOML:
> > Hi,
> >
> > looks like more general problem with 2.6.21-rc3. This happens when I
> remove my
> > PCMCIA USB2.0/IEEE1384 adapter from slot:
>
> Yes, the more important it is to know whether -rc2 works.
> And please report this as a generic sysfs failure to lkml.
>
> 	Regards
> 		Oliver
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Markus Rechberger
