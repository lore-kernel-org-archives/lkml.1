Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab0BYHi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 02:38:56 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64548 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab0BYHiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 02:38:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=m5aScAsDrzm3jtji0e9ZcxU5v7V0ZhrXbVvOjF1P/b13DWDwIv9tHeJHdjsHbs2P/Z
         9JKBtQsCw7v/GvQOTpTsPCyzTokVoBsamPWCiJGUranjPqJkF0tmXFOG3P/ZTYSFLS29
         v7IbP3D5z63mTvNXKhWXAPkU/fLpOzExhgmmo=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Input: serio - re-add thaw (and add freeze)
Date: Wed, 24 Feb 2010 23:38:49 -0800
User-Agent: KMail/1.13.0 (Linux/2.6.31.12-174.2.22.fc12.x86_64; KDE/4.4.0; x86_64; ; )
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>, linux-input@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4B69C7AA.7000904@tuffmail.co.uk> <20100216172233.GA14229@core.coreip.homeip.net> <20100225070302.GB1601@ucw.cz>
In-Reply-To: <20100225070302.GB1601@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002242338.49873.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 February 2010 11:03:03 pm Pavel Machek wrote:
> On Tue 2010-02-16 09:22:33, Dmitry Torokhov wrote:
> > On Tue, Feb 16, 2010 at 04:48:30PM +0000, Alan Jenkins wrote:
> > > On 2/4/10, Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:
> > > > Dmitry Torokhov wrote:
> > > >> On Wed, Feb 03, 2010 at 06:59:54PM +0000, Alan Jenkins wrote:
> > > >>> 633aae2 "Input: i8042 - switch to using dev_pm_ops"
> > > >>> removed handling for PMSG_THAW, causing obscure breakage.
> > > >>> 
> > > >>> It can break if you press keys during hibernation,
> > > >>> which causes subsequent keypresses to be lost -
> > > >>> so you can't cancel s2disk by pressing backspace -
> > > >>> and then just before system poweroff you get
> > > >>> "psmouse.c: Failed to deactivate mouse".
> > > >>> 
> > > >>> So let's add the thaw handler back.
> > > >>> 
> > > >>> Also set the freeze handler.  It looks like PMSG_FREEZE
> > > >>> didn't do anything in the past, but I think that must
> > > >>> have been an oversight.
> > > >> 
> > > >> We do not need to do anything special at freeze time that is why
> > > >> there wasn't freeze handler. And so thaw should be pretty much noop
> > > >> as well.
> > > 
> > > Ok, so I did some more mindless fiddling.  It seems that all it needs
> > > is to call the interrupt handler at thaw time.
> > 
> > Yep, this makes more sense. If you happen to press the key(s) while
> > interrupts are off the keyboard controller becomes "jammed". Your sign
> > off please?
> 
> Dmitry wants your Signed-off-by: line, to easily apply the patch.
>

Pavel, I already have it and it is in mainline.

Thanks.

-- 
Dmitry
