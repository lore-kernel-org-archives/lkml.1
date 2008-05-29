Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbYE2QOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbYE2QOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 12:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbYE2QOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 12:14:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:47564 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbYE2QOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 12:14:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=F09nmY1zE+u1grdxxyTQdjknn7JUGFGuPuyxk9eYAHsHBgrtWkNjoTlb0/RqaSf8lkaYuYnRFFONNTPI++1dzt7s7eM22zA2yy6C0PB1/iMH8LC9zb1c6FLnekKDFoy7y5W2peUPg8xiP/oT8g3oDjIvfk6mJN7+H7+5cPKYHKM=
Date: Thu, 29 May 2008 12:14:23 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2] Eliminate double kfree
Message-ID: <20080529121315.ZZRA012@mailhub.coreip.homeip.net>
References: <Pine.LNX.4.64.0805291504400.26229@ask.diku.dk> <20080529101012.ZZRA012@mailhub.coreip.homeip.net> <Pine.LNX.4.64.0805291754480.26229@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805291754480.26229@ask.diku.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 05:57:50PM +0200, Julia Lawall wrote:
> On Thu, 29 May 2008, Dmitry Torokhov wrote:
> 
> > Hi Julia,
> > 
> > On Thu, May 29, 2008 at 03:05:07PM +0200, Julia Lawall wrote:
> > > From: Julia Lawall <julia@diku.dk>
> > > 
> > > The variable report is only non-NULL and non-freed in a small region of
> > > code, so it should only be freed in error handling code that comes from
> > > that region.
> > > 
> > 
> > Thank you for your patch. There isn't a double-kfree though, as far
> > as I can see.
> 
> There was a double free because the error handling at the end of the 
> function (for input_register_device) would fall through to the 
> kfree(report) under err_free_devs, even though report is already freed at 
> that point.
> 

Ah, yes, indeed.. Well, that decides what branch the patch gets
applied then ;)

-- 
Dmitry
