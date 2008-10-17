Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbYJQAop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbYJQAop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 20:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYJQAoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 20:44:37 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:40393 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753482AbYJQAog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 20:44:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0D/eY5A1sf25cBA4IInW2mMSTHfkCsNukCZ8eR8k52MEj55LPwUAUIEGJbVcNlwYtGIGGJdm+VF27cYJ08kePiGstlD+Dw4bIquxmIHzZHZ46SL67UHEFZe2sR2osrKYMnGFwAgKtewhZYhs+vvSnhIqIciAPYDeOvLFx9n1HSw=  ;
X-YMail-OSG: pcvNxpQVM1nVGTmZi1U4nJRd.DQ.W2.OLvF03MlsvANAaGs8nKFr3Uj8As_diO3T5Lw89Uu_ub9jBkU3avK8SeZrC9781x0vktVxReEJIHl1HxEQTvOrPURjaDIOLseHm611iU0DmldueHOmY7pvwao2
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] gpiolib: fix oops in gpio_get_value_cansleep()
Date: Thu, 16 Oct 2008 17:44:33 -0700
User-Agent: KMail/1.9.9
Cc: avorontsov@ru.mvista.com, linux-kernel@vger.kernel.org, stable@kernel.org
References: <200810160845.22281.david-b@pacbell.net> <20081016161718.e05864da.akpm@linux-foundation.org>
In-Reply-To: <20081016161718.e05864da.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810161744.34005.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 October 2008, Andrew Morton wrote:
> > From: David Brownell <dbrownell@users.sourceforge.net>
> > 
> > We can get the following oops from gpio_get_value_cansleep()
> > when a GPIO controller doesn't provide a get() callback:
> 
> We can, but do we? ;)

I think it's unlikely without the sysfs interface.


> iow: is this needed in any -stable release?

The bug has been there since 2.6.25 but nobody else seems
to have reported it.  Is the general policy to fix all
oopses that *could* appear?  I'd send it for 2.6.27-stable,
since that's got the sysfs hooks.  And older kernels if
bug likelihood isn't a major concern.

- Dave
 


