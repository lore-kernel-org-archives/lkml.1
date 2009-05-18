Return-Path: <linux-kernel-owner+w=401wt.eu-S1753083AbZERVPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbZERVPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 17:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbZERVP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 17:15:27 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44375 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752796AbZERVP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 17:15:26 -0400
Subject: Re: [PATCH 0/6] drivers/ide Convert printk(KERN_<foo> to pr_<foo>(
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Joe Perches <joe@perches.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
In-Reply-To: <1242680389.1572.127.camel@Joe-Laptop.home>
References: <cover.1242609803.git.joe@perches.com>
	 <200905181612.43632.bzolnier@gmail.com>
	 <1242661288.1572.82.camel@Joe-Laptop.home>
	 <1242662198.6347.14.camel@mulgrave.int.hansenpartnership.com>
	 <1242680389.1572.127.camel@Joe-Laptop.home>
Content-Type: text/plain
Date: Mon, 18 May 2009 21:15:28 +0000
Message-Id: <1242681328.6347.38.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-18 at 13:59 -0700, Joe Perches wrote:
> On Mon, 2009-05-18 at 15:56 +0000, James Bottomley wrote:
> > What exactly is the point of a mechanical conversion from
> > printk(KERN_ ...) to pr_...?
> > 
> > I can see the value of the pr_ macros from new code in that the
> > temptation to put a comma after KERN_.. for some people is irresistible
> > so it's an interface that's very easy to misuse, but given that we have
> > correct uses, why convert them?
> 
> Enables easier conversion to dev_<foo> macros

Don't buy this ... this should just be done directly to avoid code
churn.

> Allows easier prefixing via pr_fmt

Buy this, but you need to say what you're proposing for pr_fmt in IDE
for this to make sense.

> Puts back together unnecessarily chopped up format strings

Staying out of this bikeshed colour discussion.

> Standardization is good

We'd only be standardising if printk is deprecated, which I don't think
it is.

> Just for the hell of it

Don't like this ... it's not good for the stability of the code base and
it can cause problems with subsidiary committers by generating
unnecessary patch rejections due to code churn.

James


