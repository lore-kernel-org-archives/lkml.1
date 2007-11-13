Return-Path: <linux-kernel-owner+w=401wt.eu-S1760648AbXKMEIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648AbXKMEIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 23:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756973AbXKMEIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 23:08:38 -0500
Received: from wr-out-0506.google.com ([64.233.184.236]:5851 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801AbXKMEIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 23:08:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XrPPem4YF8pMRfsMiKw/yVGRKvc3TXg+x30tIzJZmF8Jzj2c2Jc/bRSlcqUr925zYWFBQKv5ZBdVZiHgp1SjDJSEU8886uL2FNCVuzTmGS3ECUQkuLvwloqqOwl7L0d3DDDkdriQOdRjcz1zCVBCAXGVESo3wlXzUhraTKtigVc=
Message-ID: <804dabb00711122008t3baa8abbr81ef8ec37e8016a1@mail.gmail.com>
Date: Tue, 13 Nov 2007 12:08:35 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [PATCH] module loader should not complain about unknown symbol
Cc: "Jan Glauber" <jang@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Pavel Emelyanov" <xemul@openvz.org>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Jon Masters" <jonathan@jonmasters.org>
In-Reply-To: <200711131352.23244.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1194877107.5656.31.camel@localhost.localdomain>
	 <200711130923.12616.rusty@rustcorp.com.au>
	 <200711131352.23244.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 13, 2007 10:52 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Tuesday 13 November 2007 09:23:12 Rusty Russell wrote:
> > Better might be to put in a waitqueue and wake it up whenever a module is
> > deleted or changes status.  Then use_module() can wait if
> > strong_try_module_get() returns -EBUSY (up to 30 seconds, then print a
> > warning and fail).
>

Will it ever go into a deadlock (or likewise DOS scenario) if modA dep
on modB, but modB also dep on modA?
