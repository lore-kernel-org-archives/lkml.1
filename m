Return-Path: <linux-kernel-owner+w=401wt.eu-S1758512AbYE0SK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512AbYE0SK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 14:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756307AbYE0SKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 14:10:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:61559 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755852AbYE0SKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 14:10:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=YgH8p5hq2uKTvNjSgDrO9I0GiJHrDhdEMzkNwShkTB2NEM1UXKou47oa50G6lqaN6PM61FwADGIMPiCJuphWdYrXFVK2IWnpVThMnuM2+LvNLwd2sH+pc2CtjV+D3TVHfk8BjmPoek/ORgL1ncYvwICtfMRlkOwtjMosR8rkS6k=
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: [PATCH 14/15] rfkill: do not allow userspace to override ALL RADIOS OFF
Date: Tue, 27 May 2008 20:13:33 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, "Thomas Renninger" <trenn@suse.de>,
       "Dmitry Torokhov" <dtor@mail.ru>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <200805271638.04290.IvDoorn@gmail.com> <1211910094.13064.1255315907@webmail.messagingengine.com>
In-Reply-To: <1211910094.13064.1255315907@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805272013.33912.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 May 2008, Henrique de Moraes Holschuh wrote:
> On Tue, 27 May 2008 16:38:04 +0200, "Ivo van Doorn" <ivdoorn@gmail.com> said:
> > > So yes, I do feel RFKILL_ALL is different, and it warrants EPO semanthics in
> > > the kernel, while all other rfkill events, such as KEY_WLAN, don't.
> > > 
> > > I don't feel strongly about not giving EPO semanthics to other rfkill events,
> > > but I recommend against giving anything else EPO semanthics in rfkill.
> > 
> > You just made my 2 laptops very happy because apparently they
> > don't behave like most keys do. ;)
> > 
> > Laptop 1)
> > 	- Key to control WLAN (Broadcom)
> > 	- Key to control Bluetooth (Broadcom??)
> > Laptop 2)
> > 	- Key to control WLAN (Intel)
> 
> You don't have a SW_RFKILL_ALL switch :-)   It is the same as my ThinkPad T43,
> it does *NOT* have a SW_RFKILL_ALL switch, and it has a wireless config hotkey,
> which is handled in firmware.  The firmware can wire-kill the Intel WLAN card,
> and it can also unplug(!) the internal Bluetooth device from the internal USB
> bus.
> 
> You'd typically assign KEY_WLAN or something else to those keys, but NOT a 
> (fictitious) KEY_RFKILL_ALL.

Exactly the point I wanted to make. ;)

> > With my first laptop, the broadcom WLAN driver will register the key, but
> > it doesn't know if it is alone or if Bluetooth hardware is also present. So
> > it cannot know if it is a master switch or not.
> 
> Correct.
> 
> This is *explicitly* documented by the patches.  The broadcomm driver has to assume
> it is a slave rfkill device, and NEVER report any input events.  It has no knowledge
> of which platform the broadcomm chip was installed into, after all.  OTOH, it *will*
> report the status change through the rfkill notify chain and also through the rfkill
> uevents, and either a platform module for your laptop, or HAL (in userspace) can
> trap those, and issue the relevant input events.

And that is exactly how things should work in rfkill. ;)

> > > But of course, you have to make sure the master switch WILL bloody well stay off
> > > when off by design.  You engineer it so that all possible failure modes will
> > > cause it to go to the off state.
> > > 
> > > I would really appreciate that the rfkill class would abide to this UI notion for
> > > the master rfkill events (*_RFKILL_ALL).
> > 
> > Such a thing would indeed be nice, as long as you can positively identify
> > a master switch,
> > but as long as that is not possible/implemented it will only be confusing
> > for driver developers,
> > userspace developers and the users.
> 
> We document it *throughoutly*, and add a big fat warning about the misuse of
> RFKILL_ALL.   It should be enough.   Will you consider ACKing a new version of
> the patchset which documents better the *_RFKILL_ALL events?

Ok, with some additional documentation it should be sufficient for now.
We can later see if minor adjustments need to be made based on userspace
implementation (which with he current rfkill implementation is still very limited).

Ivo
