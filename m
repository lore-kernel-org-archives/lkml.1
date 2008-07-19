Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbYGSLhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbYGSLhc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 07:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbYGSLhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 07:37:24 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:5399 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbYGSLhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 07:37:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=jOW1rKTHZKn7PNnTiMC17IEPM2Dp63Vw5CbDk5M2gl4MAOCGzeQwJ7k2ZCjA6PgETI
         mcNf+/6GKk5+07wdKUEEVa81e9Lq/YnRB9r11ceP5Vth+p59PH+1VJN8cF43/3HRQen4
         gR1r8puz4WlbIVROwpV4xPeL5cA12XRdl4MIY=
Message-ID: <4881D205.1000901@tuffmail.co.uk>
Date: Sat, 19 Jul 2008 12:37:41 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Alexey Starikovskiy <astarikovskiy@suse.de>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] acpi: GPE fixes
References: <487D23C3.5070301@student.cs.york.ac.uk> <487F31D7.30803@suse.de> <20080717121309.GF31732@khazad-dum.debian.net> <487F3B6D.3090507@suse.de> <20080717162628.GB18457@khazad-dum.debian.net> <487F7724.5080905@tuffmail.co.uk> <20080717185032.GD18457@khazad-dum.debian.net> <487F986A.3070504@tuffmail.co.uk>
In-Reply-To: <487F986A.3070504@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's what I came up with -

1.  I was fighting against EC_FLAGS_QUERY_PENDING.  This was used to ignore
    multiple successive GPE interrupts and treat them as a single GPE instead.
    That's the exact opposite of what we want to do.  Let's get rid of it.

2.  Then we can apply my original patch to fix GPE polling on the Asus EeePC,
    by repeatedly querying for GPEs until there are none left.

3.  Finally, if I'm right then we now know how to handle "GPE interrupt storms".
    Some EC's are raising multiple interrupts before we acknowledge them. but
    they're just telling us how many events are pending.  There's no harm in
    that, so we don't ever need to disable GPE interrupts.  Let's get rid of
    GPE polling mode.  (Code mainly stolen from Alexey).

Patch 3 would benefit from wider testing.  Fortunately there are several open
bugs about GPEs so it should be easy to find testers :-).

Alan

