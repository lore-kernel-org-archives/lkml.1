Return-Path: <linux-kernel-owner+w=401wt.eu-S1761347AbYDXRf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761347AbYDXRf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 13:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756040AbYDXRfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 13:35:10 -0400
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:52147 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755443AbYDXRfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 13:35:09 -0400
Date: Thu, 24 Apr 2008 18:34:32 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Michael Abbott <michael@araneidae.co.uk>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-net@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DM9000: Reimplement 2-resource device specification
	(fwd)
Message-ID: <20080424173432.GE16284@fluff.org.uk>
References: <20080424125217.M52274@saturn.araneidae.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080424125217.M52274@saturn.araneidae.co.uk>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 12:57:08PM +0000, Michael Abbott wrote:
> From: Michael Abbott <michael.abbott@diamond.ac.uk>
>
> [PATCH] DM9000: Reimplement 2-resource device specification
>
> In commit 1a5f1c4ff80f522555d78d4dd0109f18395c6d83 a change was made to
> the handling of the resources passed the DM9000 device.  Unfortunately,
> if only two resources are passed (the read and write register in the same
> area) the pointer db->irq_res ends up being used without being initialised.
>
> This patch tidies this up a little.  Only one architecture class,
> blackfin, uses two resource specification, so it may be better to enforce
> three resource specification as before by simply removing the 0 and 2
> resource branches from dm9000_probe.

I think then we should probably make the driver simpler and remove the
special case for the two resources... any small saving of using just
two resources is probably cancelled out by the extra code needed.

> +#define res_size(_r) (((_r)->end - (_r)->start) + 1)
> +

I'd like to see something like this as an inline function in the
relevant header, and some patches to get other users to find it.

> -
>  		if (pdata->outblk != NULL)
>  			db->outblk = pdata->outblk;
> -
>  		if (pdata->dumpblk != NULL)
>  			db->dumpblk = pdata->dumpblk;

I'd rather not see spacing changes done, especially as I don't like
to see lots of code cramped together. 

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
