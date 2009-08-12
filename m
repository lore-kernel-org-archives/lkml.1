Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbZHLQBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbZHLQBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 12:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754108AbZHLQBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 12:01:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:31808 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbZHLQBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 12:01:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=aFCuXLQsP23u3XeNlFn0yiHG7I7/CeWL9EZigq5WGcoc1COLE0bhUDTtOFs1iAVI5c
         2x0tyFequ3EvK7ttz78fjRlYP67jbbSBRNjejHAtrnSgGNFZvIRUlw7iqFET31aT0VZF
         2nw6bA0vLHkCa5MJXI1r8uX+o3LneNa6dj3u0=
Date: Wed, 12 Aug 2009 09:01:28 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-input@vger.kernel.org
Subject: Re: [PATCH 2/5] [input] add mc13783 touchscreen driver
References: <1249981667-4366-1-git-send-email-s.hauer@pengutronix.de> <1249981667-4366-2-git-send-email-s.hauer@pengutronix.de> <1249981667-4366-3-git-send-email-s.hauer@pengutronix.de> <20090812024609.5EB8B526EC9@mailhub.coreip.homeip.net> <20090812111018.GC17992@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812111018.GC17992@pengutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090812163207.373B5526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 01:10:18PM +0200, Sascha Hauer wrote:
> Hi Dmitry
> 
> On Tue, Aug 11, 2009 at 07:15:33PM -0700, Dmitry Torokhov wrote:
> > Hi Sascha,
> > 
> > On Tue, Aug 11, 2009 at 11:07:44AM +0200, Sascha Hauer wrote:
> > > +
> > > +	INIT_DELAYED_WORK(&priv->work, mc13783_ts_work);
> > > +
> > > +	priv->workq = create_singlethread_workqueue("mc13783_ts");
> > 
> > Do you really need a separate workqueue? Would not keventd suffice?
> 
> Yes, I do. mc13783_adc_do_conversion() runs in a workqueue aswell. With
> keventd I would deadlock.
> 

I see. Then please add a comment why it is needed so nobody is tempted
to doa "cleanup" ;)

-- 
Dmitry
