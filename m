Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbYHTIkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbYHTIkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 04:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbYHTIjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 04:39:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:12090 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbYHTIjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 04:39:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=fA+4LZc0aOXGABWh//Nbguhm+OcVrbi0PwFKDoBPnNJtKxLlXZRV8ktZ1cVrmJxddl
         iFQAypLuNPCGZPCfkj5azr5m3TWZyUoJoe+G9reI4Ea1gkitJmalTzJX/TLt33Vtj59T
         Jh+l93rGszP6YNbu7ioN2knSZQKxj4ZCtwXsc=
Date: Wed, 20 Aug 2008 12:39:43 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david-b@pacbell.net, linux-kernel@vger.kernel.org,
       dbrownell@users.sourceforge.net
Subject: Re: [PATCH] Make gpiochip label const
Message-ID: <20080820083943.GA24244@doriath.ww600.siemens.net>
References: <1218573588-25528-1-git-send-email-dbaryshkov@gmail.com> <20080812220619.D2011362B0F@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20080817190035.GA29170@doriath.ww600.siemens.net> <20080819014305.44a1f9b8.akpm@linux-foundation.org> <bc64b4640808190413o151cfb8x7809f0e08d1f7aaa@mail.gmail.com> <20080819112828.dcfed0eb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080819112828.dcfed0eb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 11:28:28AM -0700, Andrew Morton wrote:
> On Tue, 19 Aug 2008 15:13:47 +0400
> Dmitry <dbaryshkov@gmail.com> wrote:
> 
> > 2008/8/19 Andrew Morton <akpm@linux-foundation.org>:
> > > On Sun, 17 Aug 2008 23:00:35 +0400 Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> > >
> > >> On Tue, Aug 12, 2008 at 03:06:19PM -0700, David Brownell wrote:
> > >> > > From dbaryshkov@gmail.com  Tue Aug 12 13:54:29 2008
> > >> > > From: Dmitry Baryshkov <dbaryshkov@gmail.com>
> > >> > > To: linux-kernel@vger.kernel.org
> > >> > > Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>,
> > >> > >   David Brownell <dbrownell@users.sourceforge.net>
> > >> > > Subject: [PATCH] Make gpiochip label const
> > >> > > Date: Wed, 13 Aug 2008 00:39:48 +0400
> > >> > >
> > >> > > Mark gpiochip label as a const char pointer.
> > >> > >
> > >> > > Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> > >> > > Cc: David Brownell <dbrownell@users.sourceforge.net>
> > >> >
> > >> > Acked-By: David Brownell <dbrownell@users.sourceforge.net>
> > >> >
> > >>
> > >> Sorry to disturb, but will this make into 2.6.27-rc? Thanks.
> > >>
> > >
> > > Ordinarily it would not.  Is there some reason why you think it should?
> > >
> > 
> > It fixes lots of warnings (one per each instance of code filling the gpio chip)
> 
> 
> That should have been in the changelog!
> 
> When fixing warnings or compilations errors, the compiler output should
> also be in the changelog.

Thanks for the tip. It it written somewhere?

> I don't recall seeing such warnings and I cannot make them happen with
> drivers/gpio/gpiolib.c or with drivers/gpio/max732x.c or with
> drivers/gpio/pca953x.c.  So we still don't know what this patch
> does :(

Because both mentioned drivers set gpiochip->label to non-const string.
You can check arch/arm/common/scoop.c for example of driver showing
different behaviour:

  CHECK   /home/lumag/tosa-tree/arch/arm/common/scoop.c
/home/lumag/tosa-tree/arch/arm/common/scoop.c:250:22: warning: incorrect type in assignment (different modifiers)
/home/lumag/tosa-tree/arch/arm/common/scoop.c:250:22:    expected char *label
/home/lumag/tosa-tree/arch/arm/common/scoop.c:250:22:    got char const *
  CC      arch/arm/common/scoop.o
/home/lumag/tosa-tree/arch/arm/common/scoop.c: In function ‘scoop_probe’:
/home/lumag/tosa-tree/arch/arm/common/scoop.c:250: warning: assignment discards qualifiers from pointer target type

> 
> > and is pretty much small to honour inclusion IMO
> 
> Well sure it's small.  But converting things to `const' carries a
> fairly high risk of adding new warnings or breaking the build.

Should we stage it into linux-next?

-- 
With best wishes
Dmitry

