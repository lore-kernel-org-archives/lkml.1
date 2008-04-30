Return-Path: <linux-kernel-owner+w=401wt.eu-S1759923AbYD3BEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923AbYD3BEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 21:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYD3BEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 21:04:23 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:37272 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751502AbYD3BEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 21:04:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5VhAk1ty41Stw25ZYk22TKnbvaTXQu3Lr4/42Oq+B7sEfVQHox+tt+gRB7ZNB1AB75TZDU41u7oj7vM4JtBXp9qC21B58rFtF4j8Yx8aPmdH5++WRdaDCrDIMv2AP2jAfQDG6BaenbvSV3VkZ52mbmG/Tx6YKzt4eMp5N4nAvBw=  ;
X-YMail-OSG: 7WhYrEkVM1nyctZ3E131F_VOlKkzuX6XFvUhu_O6mxDiI6VD5HRKor02sWTwOSOpcgAIYTy4zRz_pRnEyHpZtjdyQr66.up4eFKgDTBfLGTk7O6Z6oBTBgbvDqaGXTkAuro-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Nizette <bn@niasdigital.com>
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
Date: Tue, 29 Apr 2008 18:04:19 -0700
User-Agent: KMail/1.9.6
Cc: Trent Piepho <tpiepho@freescale.com>, lkml <linux-kernel@vger.kernel.org>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
References: <200804281239.51729.david-b@pacbell.net> <200804291455.39674.david-b@pacbell.net> <1209511772.311.55.camel@moss.renham>
In-Reply-To: <1209511772.311.55.camel@moss.renham>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200804291804.19518.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 April 2008, Ben Nizette wrote:
> I guess one last option (which is made hard by chip label non-uniqueness
> but I'll throw out anyway) would be
> 
> /sys/class/gpio
>         /chipa
>                 /gpio-n
>                         /value
>                         /direction
>                 /control
>         /chipb
>                 :
>                 :
> 

Or maybe:

  /sys/class/gpio
	/gpiochip-X			<-- range X..(X+ngpio)
		/device			<-- symlink, if it's known
		/ngpio
		/label
		/start			<-- maybe; start == X

with the gpio-N links probably going where you showed.  That'd be
best in terms of Purity Of Essence.

- Dave

