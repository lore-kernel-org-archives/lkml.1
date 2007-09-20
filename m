Return-Path: <linux-kernel-owner+w=401wt.eu-S1757947AbXITQQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947AbXITQQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 12:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756335AbXITQPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 12:15:54 -0400
Received: from smtp108.sbc.mail.re2.yahoo.com ([68.142.229.97]:42040 "HELO
	smtp108.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755540AbXITQPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 12:15:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=q2OHOmN1HYwvquaShSIR5hMhc9ivHNaOylsyOsQ7N1Staos/gOYbBjbdj9TVeu2BOhau4yPVLv20dmiLuMSQ1sZlJ4r0hA8yWSAHYhHpTbUIP2pwAiCFA38tERNwBs1HBrUC0gBFjmkEG4xg/gJkUlJ1RkQGSbFFTyAf5uOEe7U=  ;
X-YMail-OSG: hPgmBJQVM1nG6CR9gwbPJtOGZ2nbZAsM8zYMvN_ztUXTIPQdTLEMMmZHs7W8ApsGodl6EgwMsEQartjH.4sYwH.Xk6MDfcDmQxuK5i8Ddn_GPn0LYDItxq0YFVurHb9cRxwypi3YEv3TaCY-
From: David Brownell <david-b@pacbell.net>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: 2.6.23-rc6-mm1
Date: Thu, 20 Sep 2007 09:15:50 -0700
User-Agent: KMail/1.9.6
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Chuck Ebbert" <cebbert@redhat.com>, tilman@imap.cc,
       linux-kernel@vger.kernel.org, gregkh@suse.de, a.zummo@towertech.it
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <20070919231121.e481445c.akpm@linux-foundation.org> <3ae72650709200054u356203b9rb594f1644730071b@mail.gmail.com>
In-Reply-To: <3ae72650709200054u356203b9rb594f1644730071b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709200915.50758.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 September 2007, Kay Sievers wrote:
> 
> Isn't that all caused by the rtc driver registering itself without
> checking if it is able to grab the device? Wouldn't moving the
> request_resource() before doing any device registration do the magic?

I suspect it would.  Got patch?

I'm trying to remember why it registers before grabbing resources
(I/O region, irq) ... which is not the usual pattern, and is somewhat
of a surprise every time I notice it.  Though everything's undone on
error, so it "should" work just fine.

If that's not just some debugging leftover, the only thing that comes
to mind is that maybe it was to ensure that the resource labels in
/proc/{interrupts,ioports} clearly distinguished this from the legacy
driver.  The now-conventional way to label things there is by using
a logical name like "rtc0", which is the output of registration.

- Dave

