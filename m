Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbXLPTTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbXLPTTS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 14:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615AbXLPTTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 14:19:10 -0500
Received: from fmmailgate04.web.de ([217.72.192.242]:60055 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbXLPTTJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 14:19:09 -0500
Date: Sun, 16 Dec 2007 20:19:07 +0100
Message-Id: <49458378@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt.Domsch@dell.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] be more verbose when probing EDD
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/nhMqZAluJdTpTpEdlsTjrZUqd1fJAXsvShJ11iznsPQN2L
 0cFPimeF9P6FNu+UKzcKITUbmkZ6UCnoyf8xfqqCwyXrFGXD/g=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is awfully verbose.
yes, this was meant as an example
also mind, that the last printf with "\rOK...." is meant to overwrite the hint message, so nobody should ever notice that message. i`m just unsure if this is a good approach. i have found two occurences in linux kernel, where drivers do something similar.

> [or even "failed"...]
yes, but how to detect if we got stuck forever inside that bios probe ?
i assume that`s hard to do, so that`s why i`m printing that hint "into the future", to be overwritten on successful return.

> Also, you really should look for the "quiet" command-line option and 
> squelch the message.
sure! will add that if there is some positive feedback and someone finds this patch useful.

regards
roland


> -----Ursprüngliche Nachricht-----
> Von: "H. Peter Anvin" <hpa@zytor.com>
> Gesendet: 16.12.07 19:17:40
> An: devzero@web.de
> CC: linux-kernel@vger.kernel.org, Matt.Domsch@dell.com
> Betreff: Re: [PATCH] [RFC] be more verbose when probing EDD

> 
> devzero@web.de wrote:
> >         /* Query EDD information */
> >  #if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
> > -       query_edd();
> > +        printf("Probing EDD (query Bios for boot-device information)\n");
> > +        printf("If boot hangs here, you may have a buggy Bios. Try edd=skipmbr or edd=off");
> > +        query_edd();
> > +        printf("\rOK                                                                       \n");
> >  #endif
> 
> This is awfully verbose.
> 
> I'd prefer something like:
> 
> printf("Probing EDD BIOS... ");
> query_edd();
> printf("ok\n");
> 
> [or even "failed"...]
> 
> Also, you really should look for the "quiet" command-line option and 
> squelch the message.
> 
> 	-hpa
> 


_______________________________________________________________________
Jetzt neu! Schützen Sie Ihren PC mit McAfee und WEB.DE. 3 Monate
kostenlos testen. http://www.pc-sicherheit.web.de/startseite/?mc=022220

