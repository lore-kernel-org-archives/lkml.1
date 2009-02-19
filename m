Return-Path: <linux-kernel-owner+w=401wt.eu-S1757336AbZBSAaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbZBSAaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 19:30:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbZBSA37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 19:29:59 -0500
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:46502 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751678AbZBSA37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 19:29:59 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tUFd0/biIwP5Ah5/rv6DBrPMAOOFxz8FURjC7WGWmqAlkKcH9nlw62tzFDqzOiXFXJNaa2ypIjrGNTBh3NmNLPkGcugetZMhkfA3LaF18nyratk2x/Uab+RlJ7aNKPktCjhWu/Ogh8EURBrphkoCUD/lodv0CSlTINAePzpnvMA=  ;
X-YMail-OSG: BMspLWIVM1km9B.aC3aF4t38F2sQNg2c0_9mSGKgB8CWWv8JZDHr6KSZ2qTPUekYqOYbD2jH5_PDPm78o7Fb2nTUx7ElhBIWeqRRoFYdO7k_hT7aZzb73jIuGKw7p3k0Gr3pH5UKJRGzxzvZrevend8fOxzV7e1SBYXF7Zsi0ie9IfEJRbJ7dykAW5sG
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] spi-gpio: Sanitize MISO bitvalue
Date: Wed, 18 Feb 2009 16:29:56 -0800
User-Agent: KMail/1.9.10
Cc: Michael Buesch <mb@bu3sch.de>, linux-kernel@vger.kernel.org,
       openwrt-devel@lists.openwrt.org
References: <200902151630.41426.mb@bu3sch.de> <20090218130426.a12e6bfa.akpm@linux-foundation.org>
In-Reply-To: <20090218130426.a12e6bfa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902181629.57114.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 February 2009, Andrew Morton wrote:
> If this function is speed-critical (which is what David's comment
> implies) then perhaps this should be "fixed" by tightening up the
> (presently apparently undocumented) interface?  And then speeding up
> all the other getmiso() implementations?

All the per-bit GPIO functions can be speed-critical,
which is why they use the zero/nonzero convention
instead of demanding extra instructions to switch to
the zero/one convention.

This particular function needs the zero/one convention;
in that respect it's unusual.
