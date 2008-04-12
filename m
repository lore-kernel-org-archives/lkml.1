Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbYDLSNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbYDLSNf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 14:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756587AbYDLSNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 14:13:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:63749 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234AbYDLSNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 14:13:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=GTw/Pug+QUZXMoIdJBgHwoa6fs2hL85/lnaM66OUwGNVYTx5cSteoZs9IY9paCIzLu6B64JNR70bb1jWYZZYkfcAOGcitu1xzaNS9GV0K+vzpwhipJkGJeKUMzHX8MNjkaURB6GPrw4RhoklOhlL+BhQ+2AzmxFlVdENCGL+JSM=
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 3/8] rfkill: handle KEY_RADIO and SW_RADIO events
Date: Sat, 12 Apr 2008 20:14:41 +0200
User-Agent: KMail/1.9.9
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <20080412154711.GA3221@anvil.corenet.prv> <20080412180219.GI3402@khazad-dum.debian.net>
In-Reply-To: <20080412180219.GI3402@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804122014.41583.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 April 2008, Henrique de Moraes Holschuh wrote:
> On Sat, 12 Apr 2008, Dmitry Torokhov wrote:
> > On Fri, Apr 11, 2008 at 05:37:19PM -0300, Henrique de Moraes Holschuh wrote:
> > > The *_RADIO input events are related to all radios in a system.  There are
> > > two: KEY_RADIO and SW_RADIO.
> > > 
> > 
> > KEY_RADIO is reserved for selecting radio input (as pooosed to TV, AUX,
> > etc) with a remote control. Rfkill woudl need a separate keycode if it
> > needs "all types of radios" event.
> 
> Hmm, let me check where I got the wrong idea of using KEY_RADIO from,
> because thinkpad-acpi already uses KEY_WLAN which means that at least in
> the past I did know KEY_RADIO was not to be used for wireless data
> communication devices like that...  jeez, looks like spontaneous brain
> corruption on that topic hapenned to me sometime ago, and it came out in
> a linux-thinkpad thread a few weeks ago.  The wrong semanthics for
> KEY_RADIO seem to have stuck to my mind since then.  Drat, I *really*
> apologise for this one.
> 
> This, of course, is a major NAK for this patch.  And I am considering
> dropping the handling of KEY_<whatever replaces RADIO> completely from
> it.  SW_RADIO (after a rename, see below) still needs to be handled,
> though.
> 
> > Btw, is there any devices in the wild that actually have separate
> > switches for different types of transmitters?
> 
> Separate switches?  I know of none.
> 
> Separate hot keys/buttons?  I haven't seen it, but check commit
> 90da11514562020ea7d697982f912ac949adc317's comment.  That was the commit
> which added KEY_WLAN and KEY_BLUETOOTH, back in 2.6.18-rc.  Maybe ask
> Lennart Poettering about it?

My laptop (Acer Ferrari 3200) features 2 keys, 1 for 802.11 and 1 for Bluetooth.
Both directly communicate to the hardware itself and only need rfkill for
notification purposes to userspace.

Ivo
