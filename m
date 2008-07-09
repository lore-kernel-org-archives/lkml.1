Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbYGIVsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbYGIVsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbYGIVsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:48:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:48456 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbYGIVsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:48:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=BBUQEssD7BsSrjbGXRfPC2o16zKFPcOdEEHeA97Xhxi72exrspP8f4fvnf2XMTOAxg
         hF5vnyanolRqXiXUMGSiC1vVjmqGSq+/b/lhsClN344ExDWIBJNhZJIWjoC0aEUI13wb
         DuVXk9QSfn86YaOR2VCGiAi/WDF6nCA/FyGh0=
To: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
Subject: Re: [RESEND] [PATCH -next 2/2] acpi,rfkill,backlight: comapl-laptop update - use rfkill switch subsystem
Date: Wed, 9 Jul 2008 23:57:27 +0200
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       ak@linux.intel.com, Len Brown <lenb@kernel.org>,
       Richard Purdie <rpurdie@rpsys.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
References: <20080709231059.778d16f4@debian> <200807092333.01355.IvDoorn@gmail.com> <20080709234419.12d6eabc@debian>
In-Reply-To: <20080709234419.12d6eabc@debian>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807092357.28013.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 July 2008, Cezary Jackiewicz wrote:
> Dnia 2008-07-09, o godz. 23:33:01
> Ivo van Doorn <ivdoorn@gmail.com> napisa³(a):
> 
> > On Wednesday 09 July 2008, Cezary Jackiewicz wrote:
> > > From: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
> > > 
> > > Remove unnecessary attributes, use rfkill switch subsystem.
> > 
> > I'm missing a call to rfkill_force_state() to inform the rfkill subsystem that
> > the key has been toggled. This function should be called when the hardware
> > has raised the interrupt about the pressed event, or when the function
> > which polls the register notices the state change.
> > 
> > As the patch works now, it means that the driver will only listen to
> > events coming from rfkill and it doen't provide any updates itself.
> > 
> > Ivo
> 
> Does calling rfkill_force_state () is mandatory? This driver implement 
> get_state() hook, @state is always up-to-date.

It is not mandatory if you are writing rfkill support for a driver that does not
come with a rfkill switch. Such drivers can make use of the rfkill events produced
by the hardware which does have such a switch.

When the hardware does have the rfkill switch, then yes rfkill_force_state() is mandatory.
The get_state() callback function is optional, and allows rfkill to differentiate
between soft and hardblock.

Ivo
