Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbYE3Ehy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbYE3Ehy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbYE3Eha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:37:30 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:46592 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752506AbYE3Eh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:37:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PWFn/T+sJcH5d4GSVOGe95t7gHiDuEsK7BiEdWlbrDbx7AmfCBRY+DZeMLjwUcuSfgqC+53qHjvaGBJrb0nxNhOi96b0iC8hikgAuwYfGJVlC5aJD1Ia2HaypdmYUPC5QxZfGjuXqX4AoA3gcXQQI6g+vjIVIwC4wU9hbp6hcAk=  ;
X-YMail-OSG: ZUbCHB8VM1nz5XA1pMNuUbZ9nnfxHgv1vp054fu3t5GQmWdUFc9WTdU_yX0EQFNytOKtO.eorwTAu4OVXsBRuDQBA7FGN6zXryClEjywGGKo_qxNTqGB9c_FikJE1EeMnRM-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH] gpio: fix build errors for drivers not strictly requiring GPIOs
Date: Thu, 29 May 2008 20:28:10 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20080527142029.GA31778@polina.dev.rtsoft.ru>
In-Reply-To: <20080527142029.GA31778@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805292028.10906.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 May 2008, Anton Vorontsov wrote:
> Since commit 7560fa60fcdcdb0da662f6a9fad9064b554ef46c (gpio: <linux/gpio.h>
> and "no GPIO support here" stubs) drivers can use GPIOs if they're available,
> but don't require them.
> 
> This patch actually enables this feature, otherwise drivers will stumble
> against this:
> 
> include/asm-generic/gpio.h:111: error: redefinition of 'gpio_is_valid'
> include/linux/gpio.h:21: error: previous definition of 'gpio_is_valid' was here

This looks to me like pure user error ... what was anyone doing
including <asm-generic/gpio.h> in that way?  There are a *lot* of
bogus include combinations, and we don't try to "fix" them.

It should suffice to #include <linux/gpio.h> ... that causes the
definition of either (a) stubs in that file, *OR* else (b) the
platform-specific implementation of the GPIO calls, which may
(if that platform chooses) use <asm-generic/gpio.h> utilities.

NAK on this patch.

- dave
