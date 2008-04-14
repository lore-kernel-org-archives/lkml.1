Return-Path: <linux-kernel-owner+w=401wt.eu-S1762072AbYDNVCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762072AbYDNVCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 17:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494AbYDNVB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 17:01:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:18374 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbYDNVB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 17:01:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=bOKEw3dCPJwysCAqDPwdrc0d5GFrqx6EAJmztF8bLuw8ULnvekv+A5vIj5zEtJ3iShTJF1KsHNN7/8vSLjEEANrnMSKzVW3PKXBWiigjkVkMHENgPsNEmczvoK83zRMQVqFOGJg+Vb6PPx0zbSngomiVZw8FKl1aEUTs9N8dpHE=
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Subject: Re: [PATCH 4/8] rfkill: add read-write rfkill switch support
Date: Mon, 14 Apr 2008 23:04:42 +0200
User-Agent: KMail/1.9.9
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br> <200804141400.41319.IvDoorn@gmail.com> <200804142006.51224.carlos@strangeworlds.co.uk>
In-Reply-To: <200804142006.51224.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804142304.42716.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 April 2008, Carlos Corbacho wrote:
> On Monday 14 April 2008 13:00:41 Ivo van Doorn wrote:
> > > > See rt2x00 and b43 in driver-wireless for an example implementation
> > > > of pollable input device and rfkill
> > >
> > > They're broken by design, at least in b43's case.  Someone (Carlos, I
> > > believe?) posted an example of a ping-pong scenario using b43.
> >
> > Thats true. But was that a scenario where there were 2 keys for the same
> > radio type? Or was that a matter of the driver indicating a key pressed
> > event while it has no attached key to it, and only checked the register for
> > the key status and the current radio status and saw it was different?
> 
> Two part problem:
> 
> 1) Bug in rfkill; rfkill is toggling all devices in the same state, and not 
> actually checking the type.
> 
> (I submitted a patch for this on Sunday, although I sent it to linux-wireless 
> before you sent the MAINTAINERS patch with netdev as the official list; but I 
> did CC you on it regardless so you should have seen this. If not, let me know 
> and I'll resend it).

Completely overlooked the patch.
I found it in my archives and just acked it. :)

Ivo

> 2) The cycle-of-doom bug, as described earlier.
> 
> This still applies.
> 
> Yes, b43 can also be fixed not to emit a keycode if it cannot control the 
> rfkill switch; but that doesn't solve the case of what happens if both the 
> wireless driver and the platform driver can control the radio.
> 
> I agree wholeheartedly with Henrique here though - wireless drivers should 
> _not_ be using key press events as a reporting mechanism.
> 
> -Carlos


