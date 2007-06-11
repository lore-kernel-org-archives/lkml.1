Return-Path: <linux-kernel-owner+w=401wt.eu-S1752269AbXFKMZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbXFKMZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 08:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbXFKMZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 08:25:34 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:62806 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbXFKMZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 08:25:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DRVv/nlABR8ukhgnpAI84Da0KgqyldKM8fPf6QERPKmR/w8fgUQ8HxXV7qMCo3MVu1Oht9iCCr9hU+csNtR1p8iM4YHL48CK3Oop2cIgrTFIRk6DE/u0/OXeReRAf14pkAn1FyAfSX6zvNkfGsWSif9cTNI0i/xZyJiflv5Y+Mo=
Message-ID: <82faac5b0706110525s56bade43rb24619b54687770d@mail.gmail.com>
Date: Mon, 11 Jun 2007 22:25:31 +1000
From: "Darren Jenkins" <darrenrjenkins@gmail.com>
To: "Andi Drebes" <lists-receive@programmierforen.de>
Subject: Re: [KJ] Re: [PATCH] drivers/isdn/hisax: ARRAY_SIZE instead of sizeof
Cc: "Jan-Benedict Glaw" <jbglaw@lug-owl.de>, kernel-janitors@lists.osdl.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Karsten Keil" <kkeil@suse.de>
In-Reply-To: <200706111120.07730.lists-receive@programmierforen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706101235.09578.lists-receive@programmierforen.de>
	 <20070610131122.GB3588@pingi.kke.suse.de>
	 <20070610131402.GR2649@lug-owl.de>
	 <200706111120.07730.lists-receive@programmierforen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

G'day Andi,

On 6/11/07, Andi Drebes <lists-receive@programmierforen.de> wrote:

> > I'd suggest to not use another define, but use ARRAY_SIZE(foo)
> > _instead of_ eg. FNCOUNT.
> I thought of this, too, but I tried to keep things consistent. Let me
> explain that a little bit more in detail. If you have a look at the files
> in drivers/isdn/hisax then you will see that a lot of array size definitions
> are assigned to preprocessor macros. So I thought removing just one
> of the macros while the other continue to exist would make the code
> a little bit more inconsistent. However, one might disagree about that.
> So here's another patch that includes the changes from the original patch
> and removes the FNCOUNT preprocessor definition. Perhaps the original
> authors of the files should decide wether they want to keep it or not.

I think what was meant here was to remove _all_ the macros that you
assigned to the ARRAY_SIZE() macro.


If you look at the two advantages replacing code with the ARRAY_SIZE()
macro has;
1. More readable/consistent code.
2. Faster compile times, because of less macros being defined.

If you were to simply redefine other macro's to be an ARRAY_SIZE()
macro, the code will still contain the original macro's that people
will have to look up, so would _not_ be more readable/consistent and
you now have two stages of macro replacement, so the code will
actually take _longer_ to compile.

So to get the benefit of this change you have to _remove_ all the
macros that are somehow equivalent to ARRAY_SIZE(), and replace their
use in the code, with an appropriate ARRAY_SIZE() usage.

Darren J.
