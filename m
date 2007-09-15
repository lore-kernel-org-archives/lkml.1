Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349AbXIOPyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbXIOPyI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 11:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbXIOPx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 11:53:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:21638 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbXIOPxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 11:53:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=uhNcUKSujRdOPiSw5Yl+GVFyg3Renndub1rsON8W0VMVyHAptKl6d5tZdyA5G9V2AU76us30zKHQnAy2dLNHRI5qHanBcTaJ/eAApBl+64RDwPon97jfesvlezNB10Ib2jIMKF9/mq0jEiQ7OSpJ5cBcv0J736oyi3h+4tApI6k=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Rene Herman <rene.herman@gmail.com>
Subject: Re: Per option CFLAGS?
Date: Sat, 15 Sep 2007 16:53:47 +0100
User-Agent: KMail/1.9.1
Cc: Adrian Bunk <bunk@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Kai Germaschewski <kai@germaschewski.name>,
       Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>
References: <46EB141A.7090200@gmail.com> <20070915084754.GO3563@stusta.de> <46EBF774.2030306@gmail.com>
In-Reply-To: <46EBF774.2030306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709151653.48351.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 September 2007 16:17, Rene Herman wrote:
> On 09/15/2007 10:47 AM, Adrian Bunk wrote:
> >>> The stub source file is usually considered a good way to do this.
> >> Mmm. If I'll have to live with it, I can, but thought I'd ask if there was 
> >> some nice build trickery available instead.
> > 
> > The usual trick is to create _three_ modules:
> > 
> > Two with the foo2000 and foo2001 specific parts, and a third one with 
> > all code used by both.
> > 
> > Or if foo2000 and foo2001 differ only in small details, create one 
> > snd-foo200x module supporting both at the same time.
> 
> Thanks for the comment. Yes, first would be massive overkill in this case 
> and second somewhat annoying as one of the differences is support for 
> different resources (IRQs) among the two versions, whereas I'm checking the 
> validity of the passed in values at a time I do not know which version I'm 
> looking at yet -- knowing that requires having talked to the hardware.

If I understood you right, this is PCI, USB or other kind of devices
where module is selected according to PCI/USB/whatever IDs.

You thinking is - if module foo2000 is loaded, this is definitely a
2000 device and you can "check the validity of the passed in values"
for the device 2000 now.

Correct me if I'm wrong.

But you can do absolutely the same at runtime in unified driver,
since PCI/USB/whatever IDs are accessible to the driver.

Two drivers will most likely have code duplication.

Unified driver will be harder to read and maintain because of all
ifs/switch's/function pointers you need.

The choice depends on *how much* maintainability pain you can
tolerate by taking "unified code" path.

> Can do, but for now it seems like the two seperate modules might be cleaner. 

Can you give a bit more info what the dirrefences between devices are
in this particular cases?
--
vda
