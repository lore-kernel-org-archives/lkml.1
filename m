Return-Path: <linux-kernel-owner+w=401wt.eu-S938649AbXHIFYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938649AbXHIFYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 01:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbXHIFYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 01:24:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:41573 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbXHIFYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 01:24:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=X2X//GBQauqnQWC2+WrV5fPQNr//YCPXx85rtZlhygOpR7h/giv0hoBfiwpo5WQbE6ujyeRbiLpgQREGbjWVTau8EAHcyF4+mwGFhW4jjLO2HIJm1vxL8YITMJ1CBS4ofSL0XseTVsG4Z5wdNzmO2AMSpj8Wnz8Y9Xb3derpvgA=
Date: Thu, 9 Aug 2007 09:24:33 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [2.6.22.2 review 09/84] Fix rfkill IRQ flags.
Message-ID: <20070809052433.GB5875@martell.zuzino.mipt.ru>
References: <20070807204034.882009319@mini.kroah.org> <20070807204308.GJ23028@kroah.com> <Pine.LNX.4.64.0708072336030.26397@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708072336030.26397@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 11:37:06PM +0200, Jan Engelhardt wrote:
> 
> On Aug 7 2007 13:43, Greg KH wrote:
> >
> >added this 64-bit bug:
> >
> >        ....
> >	unsigned int flags;
> >
> > 	spin_lock_irqsave(&task->lock, flags);
> >        ....
> >
> >irq 'flags' must be unsigned long, not unsigned int. The -rt tree has
> >strict checks about this on 64-bit so this triggered a build failure.
> 
> Since the check is a compile-time one, would not it be good to add
> it to the regular linux tree too?

BUILD_BUG_ON was tried, but due to amazingly wrong moment of merging
survived only for a day or so. There will be a second try, though.

