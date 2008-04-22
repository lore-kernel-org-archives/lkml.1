Return-Path: <linux-kernel-owner+w=401wt.eu-S1757016AbYDVTd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbYDVTd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 15:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbYDVTdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 15:33:18 -0400
Received: from hu-out-0506.google.com ([72.14.214.231]:27426 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbYDVTdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 15:33:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=CqhcHgjqx+Z1mjb8g7qESipOvqP3TJeOVV1orurFAM06UKNfjO25VkZcmsJdqbnPOwMFN0hiWXTjbRgoXWJJo2OxLiC3BSlzFFvdEl7zPWeUYrkcYhqKVyEcPDsDVIP/2SQvFMAEWtsg1ajFlnPWCc7GCup+mKM747zf0lghzTk=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] xfs: #define out unused parameters of?xfs_bmap_add_free and xfs_btree_read_bufl
Date: Tue, 22 Apr 2008 21:32:38 +0200
User-Agent: KMail/1.8.2
Cc: Eric Sandeen <sandeen@sandeen.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20080419142329.GA5339@elte.hu> <200804221950.54827.vda.linux@googlemail.com> <20080422182830.GD28933@cs181133002.pp.htv.fi>
In-Reply-To: <20080422182830.GD28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804222132.38169.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 April 2008 20:28, Adrian Bunk wrote:
> > Eh... I meant "no warnings about unused parameters" for fs/xfs/* only,
> > not for the entire kernel. I filter out other warnings.
> > 
> > I want to do it not as an excercise in perfectionism,
> > but as means of making sure we do not waste stack
> > passing useless parameters, which is important for xfs.
> 
> That's not really maintainable,

Why? Adding -Wunused -Wunused-parameter in fs/xfs/Makefile:

EXTRA_CFLAGS += -I$(src) -I$(src)/linux-2.6 -funsigned-char
#EXTRA_CFLAGS += -Wunused -Wunused-parameter

and making a test build with it uncommented once in a while
will reveal a bit of fallout, which is then fixed.
busybox source is thrice as big as xfs source
and from the experience I'd say it's not difficult
to keep it in shape.

> and the stack gains are too small for  
> bringing us significantely nearer to a solution.

I promise to take a look at the critical (wrt stack use) path next.
--
vda
