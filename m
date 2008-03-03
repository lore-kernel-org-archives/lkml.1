Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbYCCOme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbYCCOme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 09:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbYCCOm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 09:42:26 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:16935 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbYCCOm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 09:42:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LuXawa2V7+O65XMrFJSUxbcZjVbYkcaevx2wfZaASmhan1WHzsOfhKARgPWt2yxr6dK7rdyFMVF8CfHe9Yw7yBCiWHcjiHmU7V12ymMQ7gQsXcIvkGPGX7d+HIjMtK+k70aAfiSrPSfZEHlgj0CCvCVG5/61WWrRZq8PQvmeClE=
Message-ID: <cfd18e0f0803030642m62cec927p80f1250fbe98afc6@mail.gmail.com>
Date: Mon, 3 Mar 2008 15:42:24 +0100
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: SCHED_IDLE documentation
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Christoph Hellwig" <hch@lst.de>,
       cbe-oss-dev@ozlabs.org, "Jeremy Kerr" <jk@ozlabs.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080303125227.GA22160@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1203376368.275756.252634247263.1.gpush@pokey>
	 <200803030612.28039.arnd@arndb.de> <20080303051719.GA26102@lst.de>
	 <200803030721.52869.arnd@arndb.de> <20080303073311.GB5934@elte.hu>
	 <cfd18e0f0803030040l667dd2b7v6298e78c5b21bfec@mail.gmail.com>
	 <20080303092422.GA18281@elte.hu>
	 <cfd18e0f0803030431n69df391dw53843d5079d906dd@mail.gmail.com>
	 <20080303125227.GA22160@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

One more thought while we're in this thread.  In my recent tests I
notice that the magnitude of the effect of nice values has changed
quite a lot in recent times.  For example, back in 2.6.18, two CPU
intensive processes would get the following shares of the CPU over 100
seconds of run time (here, three different examples of nice value
settings):

A nice	B nice	%A	%B
-20	-10	58.3	41.7
-20	  0	89.2	10.8
-20	+19	99.7	 0.3

In 2.6.25-rc2, we have:

A nice	B nice	%A	%B
-20	-10	 90.5	9.5
-20	  0	 99.0	1.0
-20	+19	100.0	0.0

While I realise that nice values are not intended to guarantee any
particular degree of access to the CPU, these wide variations in the
effect of the nice value are surprising.  (For the 2.6.25-rc2 -20/+19
case, my test shows the low priority process is getting 0.000% of the
CPU -- i.e., < one thousandth of a percent.  In other words it is in
effect being totally starved of the CPU.)  Any comments?

Cheers,

Michael
