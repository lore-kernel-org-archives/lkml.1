Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab0BXTCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 14:02:44 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:39473 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757364Ab0BXTCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 14:02:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EJOxLx6X3Wr82bDovXLe+55nwjPNeXYby8oRBlkFWG6Nu+I8XHd9pvVURKRobXMbiH
         wb76xcDUrOvJAPnhc/vNwtBEOuVTVZv+eJH1dWagwuO6sXu80T9+tcxaSSCLWYOxS4AX
         zZj5lLw/9z/toNAEvO/1kUCeX40TRg3ZSEfwY=
Date: Wed, 24 Feb 2010 11:02:34 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/14] Regulators: wm8400 - cleanup platform driver data
 handling
Message-ID: <20100224190234.GD25304@core.coreip.homeip.net>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
 <20100224073849.15964.62321.stgit@localhost.localdomain>
 <20100224102548.GG18896@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100224102548.GG18896@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 10:25:49AM +0000, Mark Brown wrote:
> On Tue, Feb 23, 2010 at 11:38:50PM -0800, Dmitry Torokhov wrote:
> > Driver data set by platform_set_drvdata() is for private use of
> > the driver currently bound to teh device and not for use by parent,
> > subsystem and anyone else.
> > 
> > Also have wm8400_register_regulator() accept 'sturct wm8400 *'
> > instead of generic device structure.
> 
> Nack due to this change - this change would make it impossible for
> callers to actually call the function.  Note that nothing including only
> wm8400.h even has a struct declaration, much less defniition, for struct
> wm8400.

If you notice I added forward declaration of "struct wm8400" to wm8400.h
thus users can pass around pointer to the structure.

I really think we should refrain from passing naked 'struct device *'
pointers as much as possible since it is error prone. Otherwise
wm8400_register_regulator has no way of ensuting that passed  'dev' is
indeed wm8400.

-- 
Dmitry
