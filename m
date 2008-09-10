Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbYIJVgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbYIJVgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 17:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYIJVg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 17:36:29 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:33394 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752787AbYIJVg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 17:36:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qgvbciIy4rntWkxBdF84X8f025liTzcPxiVpjPWQiN/U8nSZKJ/BUoWUGSIIqMaQr+3LdieN3UwjT2XrWBLjn4L235eVW71k9tIwSoGC8SJsY0c+EVUIDboSWocaK7lQd8w+QtAYKhZJrB+5T8ripv+d+7N2599SjxLwcmZpFfk=  ;
X-YMail-OSG: 1c4YzfcVM1kwnRJqwKl13q0C.HXi3PwbReocY.92r8uTnK2jg5Yw2GTcDwh6fkBMeBNgezUYT.PJQyzSy.iB0Vb5Y8UJqkoRW_lr0rUYUQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] fix RTC_CLASS regression with PARISC
Date: Wed, 10 Sep 2008 14:36:25 -0700
User-Agent: KMail/1.9.9
Cc: rdunlap@xenotime.net, akpm@linux-foundation.org,
       James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
       alessandro.zummo@towertech.it, tglx@linutronix.de
References: <20080910140417.bc35c199.akpm@linux-foundation.org> <200809101419.05499.david-b@pacbell.net> <20080910.142047.265458325.davem@davemloft.net>
In-Reply-To: <20080910.142047.265458325.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200809101436.26162.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2008, David Miller wrote:
> > 
> > I don't think anyone in particular has been _pushing_ to resolve these
> > NTP related issues ... lack of urgency.  Maybe it's fair to think of
> > that as a process issue.  If DaveM wants SPARC64 to completely remove
> > its legacy RTC support for some release (which?) then:  (a) great! and
> > (b) that should be sufficient urgency.
> 
> Well, firstly my RTC sparc work is 2.6.28 targetted.

Fine; Andrew and Thomas won't need to worry about this patch
for now, then.


> Secondly, that sleeping capability is only really needed for I2C based
> RTC chips, of which sparc isn't currently making any use of.

Not quite right.  The RTC calls you make grabs a mutex; *ALL* calls
into the framework are made in task context.  Even if the underlying
RTC happens to be the type with registers on the CPU bus, where
there's no need to sleep when reading values.

Of course, you're very unlikely to sleep while waiting for that
mutex; or even while holding it, if you stick to Sun hardware.
Someone running Linux on one of the FPGA-based SPARCs might well
use an I2C based RTC though.

- Dave
