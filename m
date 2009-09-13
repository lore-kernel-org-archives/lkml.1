Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbZIMFup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbZIMFup (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 01:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbZIMFun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 01:50:43 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:25178 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbZIMFun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 01:50:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=eV5UdiVTa9FOa+Is1bhPHS+cvviyhEcI3z9f/N07Q8fvptpDQXcXqkeQ76C1fl7T9i
         jUfU2D2ePfvnVch0Zj2F3MmmRXNHjvU90cDplDzV5yivXQWj1+sfWlaAvolj8ygjGJ7X
         mwfWhvTZGTNEV7qtW7S47OQ559x4s9J4Kc2oU=
MIME-Version: 1.0
In-Reply-To: <8b5805ff0909122155u77a869c5t89a81fbf1a7eb391@mail.gmail.com>
References: <8b5805ff0909111906j68c20c3yf7226f2798a67d80@mail.gmail.com>
	 <1252721641.28368.34.camel@desktop>
	 <8b5805ff0909120359g2faf661br463b19518d935110@mail.gmail.com>
	 <4AABD122.2000400@gmail.com>
	 <8b5805ff0909121717w1516c273k2a568779b9c31662@mail.gmail.com>
	 <8b5805ff0909121726g2f1a78c1o1ff7289e059eabe5@mail.gmail.com>
	 <4AAC4315.6010102@pobox.com>
	 <8b5805ff0909121941y38b7764fv3cc4d0b5c1ba6c89@mail.gmail.com>
	 <4AAC632E.3090902@pobox.com>
	 <8b5805ff0909122155u77a869c5t89a81fbf1a7eb391@mail.gmail.com>
Date: Sat, 12 Sep 2009 23:50:45 -0600
Message-ID: <51f3faa70909122250o59fcd174ifee4277ba25a20fe@mail.gmail.com>
Subject: Re: [PATCH] libata: Add pata_atp867x driver for Artop/Acard ATP867X 
	controllers
From: Robert Hancock <hancockrwd@gmail.com>
To: "Jung-Ik (John) Lee" <jilee@google.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Daniel Walker <dwalker@fifo99.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Grant Grundler <grundler@google.com>,
       Gwendal Grignou <gwendal@google.com>, Eric Uhrhane <ericu@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 12, 2009 at 10:55 PM, Jung-Ik (John) Lee <jilee@google.com> wrote:
> I agree in that it's hard to measure/signify the additional overhead,
> since those io insts are already too slow.
> Anyways, the two extra "if"s and one PIO_MASK on every ioread/iowrite
> are pure overhead on top of in/out insts.

I don't think that any platform currently breaks if you use the
readX/writeX instead of ioreadX/iowriteX on iomapped MMIO addresses
(and there's certainly enough code in libata that does this), but the
API definition really expects that you should be using ioread/iowrite
so it would probably be best not to add any more of these..
