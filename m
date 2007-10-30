Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbXJ3Qx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbXJ3Qx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 12:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbXJ3QxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 12:53:21 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:54212 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbXJ3QxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 12:53:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Co5zdc+DEpnZY9aROCohoftMazUThFx2ztStKbmYXOszC49VpTZ5cF5eL/Uz3McOMTdK+HXqWPuBYlVHfjOiN4yRQxWriRr5ib6J1RMVauc0jhv1YObC5UlxTr7SrhFNkoeUin/uceGvbRp3UpNEGsUvHBM7icbF7RlZ6VC7Imk=
Message-ID: <d120d5000710300953kd145c7fg53f4fa4d41fbc9c3@mail.gmail.com>
Date: Tue, 30 Oct 2007 12:53:17 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "H.J. Lu" <hjl@lucon.org>
Subject: Re: PATCH: PR Input Devives/2082: PS/2 mouse out of sync after switching with KVM switch
Cc: "linux kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20071030135304.GA24688@lucon.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071030135304.GA24688@lucon.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/30/07, H.J. Lu <hjl@lucon.org> wrote:
> The bug report is at
>
> http://bugzilla.kernel.org/show_bug.cgi?id=2082
>
> Problem Description: When switching to another machine with a KVM
> switch and back, the mouse is out of control, with X.Org.  To recover,
>  I have to unplug the mouse cable and plug it back.
>
> Steps to reproduce: Have a wheel mouse connected and X.Org.  Keyboard,
> Mouse and Video are connected to a KVM switch. Switch to another
> machine and back.  You have lost the usage of wheel on mouse.
>
> This patch for 2.6.23 tries to reconnect the mouse after KVM switch.
> It doesn't completely solve the problem. Mouse still got a few random
> bytes after KVM switch.

Have you tried psmouse.resync_time=5 option?

Any change you coudl do

echo 1 > /sys/module/i8042/parameters/debug

before switrching KVM back and forth and send me dmesg?

> But it recovers with kernel message:
>
> psmouse.c: Wheel Mouse at isa0060/serio1/input0 lost synchronization, issuing reconnect request.
>
> instead of
>
> psmouse.c: Wheel Mouse at isa0060/serio1/input0 lost synchronization, throwing 3 bytes away.
>
> and never recovering from it.
>

I am hesitant queuing reconnect immediately - if the byte was delayed
because embedded controller was busy doing something else and we start
querying mouse at the wrong time we might lose mouse altogether.

-- 
Dmitry
