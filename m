Return-Path: <linux-kernel-owner+w=401wt.eu-S1757709AbZKCDDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709AbZKCDDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 22:03:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757554AbZKCDDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 22:03:44 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:50096 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702AbZKCDDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 22:03:43 -0500
Date: Mon, 02 Nov 2009 22:02:43 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: scheduling while atomic acpi_idle_enter_bm
In-reply-to: <20091027165345.3237d3df@infradead.org>
Message-id: <alpine.LFD.2.00.0911022156420.21361@localhost.localdomain>
References: <43e72e890910271640n7fafc8edpc14143fcfca7df60@mail.gmail.com>
 <20091027165345.3237d3df@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I get this when modprobing some module I am working on. I figured it
> > was the module's fault but the EIP points to something else so I am
> > not sure. I get the following repeating about 4 times on 2.6.32-rc5:
> 
> 
> you can get this if your own code leaves interrupts disabled in a
> kernel thread and then lets the cpu go idle...

Unclear.

acpi_enter_idle_bm() assumes that it is entered with irqs enabled,
and so it we unconditionally disables IRQs.

Then we unconditionally re-enable them.

The problem seems to be that right after we enable them,
we find that they are actually disabled, perhaps as
a side-effect of SMM.

Is your machine a Dell, per chance?

Please test the patches in this bug report:
http://bugzilla.kernel.org/show_bug.cgi?id=14101

thanks,
Len Brown, Intel Open Source Technology Center 
