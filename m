Return-Path: <linux-kernel-owner+w=401wt.eu-S1762647AbXHQQc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762647AbXHQQc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 12:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbXHQQcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 12:32:22 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:52401 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbXHQQcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 12:32:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=KW1fm9orphxsRNJZ/f5KSeHaDTLt+/XctnIBjsTmrIAO81OgwxExSjhmmOyi85j+/S86LDLl+VlI1+M0oXWrtXra1rf9rOd2cjI7ySvzz446l9fmLVemH/cZvabdwWM49u+dfjb9s2ML73Gl9aqLw63IpGeWuhVMEDR+EIn5VCI=
Message-ID: <3ae72650708170932y5369213bq3479708216923edb@mail.gmail.com>
Date: Fri, 17 Aug 2007 18:32:19 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Atsushi Nemoto" <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH] rtc: Make rtc-ds1742 driver hotplug-aware
Cc: david-b@pacbell.net, jengelh@computergmbh.de, a.zummo@towertech.it,
       linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
       "Greg KH" <greg@kroah.com>
In-Reply-To: <20070818.011501.41012303.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708170823.15894.david-b@pacbell.net>
	 <Pine.LNX.4.64.0708171736170.30502@fbirervta.pbzchgretzou.qr>
	 <200708170902.01260.david-b@pacbell.net>
	 <20070818.011501.41012303.anemo@mba.ocn.ne.jp>
X-Google-Sender-Auth: 5f082f1ab461839d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/17/07, Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> On Fri, 17 Aug 2007 09:02:00 -0700, David Brownell <david-b@pacbell.net> wrote:
> > Because for some reason the driver name isn't rtc-ds1742 ...
> >
> > My preferred style for such patches puts the MODULE_ALIAS up
> > near the strange driver name, so it's more clear what's going
> > on.  Putting all the MODULE_*() stuff at the end of the file
> > gets confusing in this case.
>
> OK, then I should update my patches anyway ;)
>
> Which do you prefer, MODULE_ALIAS or change some strings?
>
> I guess there are some out-of-tree users of this driver, but fixing
> them is really trivial, so I don't think this is a big compatibility
> problem.

Again, the only sane solution is to provide MODALIAS="platform:<name>"
from the platform bus, and adding the aliases to drivers who support
autoloading. Modalias strings are not free-text strings, they are
required to be prefixed by the subsystem.

I still fail to see why platform must be different from everything
else in the kernel. Please change that stuff, and the bugs which we
are fighting magically go away, because module-init-tools alias
resolving works like it does for every other subsystem in the kernel.

Thanks for considering,
Kay
