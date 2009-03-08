Return-Path: <linux-kernel-owner+w=401wt.eu-S1751460AbZCHIeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbZCHIeH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 04:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbZCHIdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 04:33:54 -0400
Received: from mail-bw0-f178.google.com ([209.85.218.178]:39570 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbZCHIdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 04:33:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=k7PyyyLxo4vR02dnHreT5tMWTsnu8eSGXCOj+X/4Vc++utWRbIJiB2RvonFk8NeeJK
         KlPNRcrHuhy6TXlwNGCb3oabOKDuC5drEwlVPwHVCLo00IqpD+iyABjTywiUjZhyKnGN
         +YaQehSiMmkFtUnpbjpqqhL0+z66AyoXB7WIE=
MIME-Version: 1.0
In-Reply-To: <20090307202647.GA9776@srcf.ucam.org>
References: <20090306003941.GA32403@srcf.ucam.org>
	 <E1LfqwF-000B1G-00.arvidjaar-mail-ru@mx3.mail.ru>
	 <20090307150640.GA3516@srcf.ucam.org>
	 <200903071839.16508.arvidjaar@mail.ru>
	 <20090307154424.GA3909@srcf.ucam.org>
	 <15e53e180903071219q4ed318edt2fa8f492426c0ab6@mail.gmail.com>
	 <20090307202647.GA9776@srcf.ucam.org>
Date: Sun, 8 Mar 2009 08:33:48 +0000
Message-ID: <15e53e180903080033h5e990f08o3622afae018c38ca@mail.gmail.com>
Subject: Re: [PATCH] toshiba_acpi: Add full hotkey support
From: Richard Hughes <hughsient@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, hal@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 7, 2009 at 8:26 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Sat, Mar 07, 2009 at 08:19:51PM +0000, Richard Hughes wrote:
>
>> Mapping KEY_SUSPEND to hibernate is just insane. Can you please change
>> the toshiba driver to use KEY_HIBERNATE and KEY_SUSPEND as thinkpad
>> now does? Thanks.
>
> Mapping KEY_SUSPEND to hibernate is what we've been doing for years.
> It's what hal *still does*.

Sure, but how much userspace now listens to HAL for these events? Xorg
and evdev has taken over that role for all the session. We can ship a
trivial patch as an fdi file to HAL to remap this if required.

> KEY_SLEEP has been the suspend to RAM key forever.

Except if you're a USB keyboard. Grep through the kernel sources and
see how many drivers get this wrong. We can't map three sleep states
to two buttons in any sane way. For instance, is the sleep acpi button
supposed to trigger a suspend of hibernate? Surely this is user policy
as it is not specified on the the exterior of the machine.

> How are we supposed to perform this transition? We've no idea
> how much of userspace makes the same assumption.

FWIW, I think emitting KEY_ events (not switch events) in HAL is crazy
as now we can just use the fixed Xorg in the session. FWIW, HAL gets
other keys wrong too, for instance KEY_BATTERY is mapped to
display_off, but nobody has noticed as we've been using Xorg since
ages.

Richard.
