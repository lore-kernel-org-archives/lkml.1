Return-Path: <linux-kernel-owner+w=401wt.eu-S1761450AbYDLKfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761450AbYDLKfw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 06:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759090AbYDLKfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 06:35:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:59745 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758846AbYDLKfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 06:35:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=mdMw7AYVcyty8eDVM2QAZmEAP7uZorw1Ci5D47n0DI91tWsgF9weqET3vPYRcwcdG1ukTh7qzi4XYaLZdvzQR+OdfU5cTGu9c/qc0IVNGOqv50uAHdGdwfYmNUiy9SB1aVAyKiGH6qx8bpIXLCwJkh++gJYo8rI2xFRIURfBsrk=
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 4/8] rfkill: add read-write rfkill switch support
Date: Sat, 12 Apr 2008 12:36:43 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <1207946244-14525-5-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1207946244-14525-5-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804121236.43547.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Currently, rfkill supports only write-only rfkill switches.  There is no
> provision for querying the current switch state from the hardware/firmware.

No that is by design, the input_polled_dev interface is there for polling.

> This is bad on hardware where the switch state can change behind the
> kernel's back (which is rather common).  There is no reason to keep kernel
> state incorrect, when we have the possibility to match reality.
> 
> There is also the issue of read-only rfkill switches (support to be added
> in a later patch), which absolutely requires support to read the current
> state from the hardware in order to be implemented.

See rt2x00 and b43 in driver-wireless for an example implementation
of pollable input device and rfkill

> In order to implement the read/write functionality:
> 
> Add a get_state() hook that is called by the class every time it needs to
> fetch the current state of the switch.  Add a call to this hook every time
> the *current* state of the radio plays a role in a decision.
> 
> Also add a force_state() method that can be used to forcefully syncronize
> the class' idea of the current state of the switch.  This allows for a
> faster implementation of the read/write functionality, as a driver which
> get events on switch changes can avoid the need for a get_state() hook.
> 
> If the get_state() hook is left as NULL, current behaviour is maintained,
> so this change is fully backwards compatible with the current rfkill
> drivers.
> 
> If the firmware is event driven, leave get_state() NULL in the driver, set
> the initial state properly before registering the rfkill class, and use the
> force_state() method in the driver to keep the class up-to-date.
> 
> get_state() can be called by the class from atomic context. It must not
> sleep.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: Dmitry Torokhov <dtor@mail.ru>

I'm going to NACK this patch.

Ivo
