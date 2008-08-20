Return-Path: <linux-kernel-owner+w=401wt.eu-S1756289AbYHTPuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbYHTPuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 11:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbYHTPur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 11:50:47 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:40423 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751624AbYHTPur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 11:50:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=N2cUqKm1YgXgaI6FbiDwvTfNGA3SKpAR8SZM2Z1HDEEvUrzn/I3uGWjvgnJFkASigjUgXWyznetS3n34q24tC4p5ki61qgrTw6OOg8nmQ02KLzJeja7Z7+ZRozD6ZkFZZD6vPlUlqLbVYzbRfiqq7Me9F7a64r+vrOobjpqFXV4=  ;
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: [PATCH] Make gpiochip label const
Date: Wed, 20 Aug 2008 08:50:41 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1218573588-25528-1-git-send-email-dbaryshkov@gmail.com> <20080819112828.dcfed0eb.akpm@linux-foundation.org> <20080820083943.GA24244@doriath.ww600.siemens.net>
In-Reply-To: <20080820083943.GA24244@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200808200850.41758.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 August 2008, Dmitry Baryshkov wrote:
> > I don't recall seeing such warnings and I cannot make them happen with
> > drivers/gpio/gpiolib.c or with drivers/gpio/max732x.c or with
> > drivers/gpio/pca953x.c.  So we still don't know what this patch
> > does :(
> 
> Because both mentioned drivers set gpiochip->label to non-const string.
> You can check arch/arm/common/scoop.c for example of driver showing
> different behaviour:

You're doing it wrong -- in a small way, not a big one.  Instead of

	devptr->gpio.label = dev_name(&pdev->dev);

do

	devptr->gpio.label = "scoop";
	devptr->gpio.dev = &pdev->dev;

No warnings generated that way, and another field is set up...

- Dave

