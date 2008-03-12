Return-Path: <linux-kernel-owner+w=401wt.eu-S1753717AbYCLXIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbYCLXIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 19:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbYCLXH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 19:07:57 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:28958 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752139AbYCLXH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 19:07:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PFBuzGKbVm5dOqnFVS3hPYP1j1O7n6OJs4e1akOBFjLVXkYsIkpWJHSlYq6pUSEsKlTGEiWx7qjFo5vKwv6yZpryyx0IqJI3tvoCCdW7XLjc+aSSP1N6dJVgk3M8+YKgjnVFGJixVWB4ezoIxsj1VzQBU2Ob99QXadEtGmqdEos=  ;
X-YMail-OSG: T6IYeRQVM1nb4m3hFWFkUP14j7kMYXal_9wRbUp5edzKun31hEQTHISLCOkAJn_cyo8dgy6eXg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: avorontsov@ru.mvista.com
Subject: Re: [PATCH 3/3] gpiolib: add __must_check attribute to the gpiochip_add function
Date: Wed, 12 Mar 2008 15:07:53 -0800
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20080311174129.GC12397@localhost.localdomain> <200803111402.38671.david-b@pacbell.net> <20080312123913.GA13266@localhost.localdomain>
In-Reply-To: <20080312123913.GA13266@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803121607.54348.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008, Anton Vorontsov wrote:
> On Tue, Mar 11, 2008 at 01:02:38PM -0800, David Brownell wrote:
> > On Tuesday 11 March 2008, Anton Vorontsov wrote:
> > > 
> > > Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> > 
> > I'm curious why you want to change this.   When it fails, a
> > KERN_ERR message is emitted ...
> 
> Ah, I missed that the gpiochip_add() issuing pr_err(), not pr_debug().
> 
> So, please just ignore that patch.

OK ...

> Though, printing errors from the 
> generic functions is confusing, you never know when your code or the
> function you call should print the error. And usually generic functions
> tend to be silent...

The logic in this case was that I don't really expect platform
setup code to check this stuff any more than it checks IRQ setup.
But, as the comment says, if platform setup code goofs, it can
cause un-bootable systems.  Ergo the pr_err().

It could be argued either way; that's just what I did, way back
when I noticed the issue.

- Dave
