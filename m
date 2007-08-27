Return-Path: <linux-kernel-owner+w=401wt.eu-S934077AbXH0Vx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934077AbXH0Vx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761188AbXH0VnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:43:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:41799 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765511AbXH0VnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:43:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=SIyoxvoLl3GA0TQ7cnuT57UY8/diZfmOoProfpA1OhGNp6i5I5+9QuIrd7epbPAKqcdFmJXFu9oF1+XEGA8cWgId7CTeN/+oqWw9H/7Wt9cNJrvtgVrA60WHiPAdLu+slNCCCZSv+fBH58CkNPzn4SnItYuvOb7ZjfNTyEv2IuY=
Message-ID: <fb4a4650708271443v221bdf8aq74f2ee8401479136@mail.gmail.com>
Date: Mon, 27 Aug 2007 18:43:04 -0300
From: "Thiago Ramos dos Santos" <dimtracker@gmail.com>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: Configuring previously loaded module
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <3ae72650708261515q66fc473fua4b99728e4d5a3f8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fb4a4650708261502v5b64ca6ev680599ad9eb58b3@mail.gmail.com>
	 <3ae72650708261515q66fc473fua4b99728e4d5a3f8@mail.gmail.com>
X-Google-Sender-Auth: 4da7f2881ec1c62e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It worked.
Thanks a lot.

Thiago

On 8/26/07, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On 8/27/07, Thiago Ramos dos Santos <dimtracker@gmail.com> wrote:
> > I have 2 devices which use the usbserial module: a CDMA modem and a
> > Palm PDA (to be more especific, the PDA uses the visor module, which
> > uses the usbserial).
> > When I plug the PDA to the computer, the visor module gets
> > automatically loaded by the kernel, and so is the usbserial module.
> > When the modem is pluged, the module is not loaded automaticaly, so I
> > created a hotplug entry for it.
> > For both devices I put rules in udev configuration files, so they are
> > autmaticaly mapped to the same /dev node in despite of the ttyUSB*
> > node they are mapped to.
> >
> > The problem is that the modem requires the usbserial module to be
> > loaded with some parameters: product=xxxxx vendor=xxxxx. So, if I plug
> > the PDA first, the usbserial is loaded without those parameters, and
> > when the modem is pluged, the ttyUSB nodes are not created for it. So
> > I have to manually unload both the visor and usbserial modules, reload
> > the usbserial with the specific parameters (to get the ttyUSB nodes
> > for the modem) and reload the visor module (to recreate the ttyUSB
> > nodes for the PDA).
> >
> > Is there anyway to configure the previously loaded usbserial module
> > with the modem parameters without having to unload it? If it is not
> > possible, is there any other solution?
>
> Try putting:
>   options usbserial product=xxxxx vendor=xxxxx
> in:
>   /etc/modprobe.d/serial
>
> Kay
>
