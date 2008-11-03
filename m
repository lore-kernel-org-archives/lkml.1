Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbYKCOwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbYKCOwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 09:52:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbYKCOvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 09:51:53 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:48277 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753668AbYKCOvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 09:51:52 -0500
X-Sasl-enc: s7U5jRRpOtucg6tnbuUO0HWzjhgUS3oVoJWmMhfuO7iz 1225723910
Date: Mon, 3 Nov 2008 12:51:45 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: eeepc-laptop rfkill, stupid question #4
Message-ID: <20081103145145.GD31078@khazad-dum.debian.net>
References: <490B3BB5.8060801@tuffmail.co.uk> <20081031171126.GA17313@srcf.ucam.org> <490B4014.4040009@tuffmail.co.uk> <490B70A3.8010108@tuffmail.co.uk> <20081102040008.GB29606@khazad-dum.debian.net> <490D8C4E.3010201@tuffmail.co.uk> <20081102130655.GA12766@srcf.ucam.org> <20081103141628.GB31078@khazad-dum.debian.net> <20081103141836.GA31894@srcf.ucam.org> <490F0ACC.4000808@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490F0ACC.4000808@tuffmail.co.uk>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Nov 2008, Alan Jenkins wrote:
> >> Can you read the state?  If so, you need to unconditionally do so on resume
> >> (from sleep or hibernation) and rfkill_force_state() it.
> >
> > The rfkill core actually forces the state on resume, so I think we're 
> > fine.

Not if you can enter or exit HARD_BLOCK, you're not.  If you cannot it is
fine.  But if you can, you really need to rfkill_force_state() on resume,
even if you have a get_state() hook.

This might be something that needs explicit documentation, or something
wanting a fix.

> I think the reason it works is because eeepc-laptop provides a
> "get_state" callback.  rfkill can call get_state on resume, and if the

It doesn't call get_state on resume right now, because rfkill_toggle_radio()
optimizes that away when called in forced mode.

I will think about removing that "optimization".

> state has changed, force it back to the old value.  So I think it's ok
> as is.

And the rfkill core seems to be buggy when you call force_state() on resume,
which you guys didn't hit because you're not doing it yet.  See my other
email...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
