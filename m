Return-Path: <linux-kernel-owner+w=401wt.eu-S934695AbZDHRq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934695AbZDHRq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbZDHRqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 13:46:17 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:55508 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbZDHRqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 13:46:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:x-accept-language:mime-version:to
         :cc:subject:references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=HT8zoeXkgnilpR2DjLySeX0IRvnoogRHLOsD1Tg/L27Ojyhrvmo9fJjysBEzRPprOk
         fpn1eahCsHI9bW3iSDaWhtXXvA9Y2wP0ShttjwehB4QKhwrZjD6qW03T1j8xTSqoxtBx
         i/bs5lIKn7aiQtWJgzAd2Qu4B/P3DAORQpTyY=
Message-ID: <49DCE2E3.7050700@googlemail.com>
Date: Wed, 08 Apr 2009 19:46:11 +0200
From: Michael Riepe <michael.riepe@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: de-de, de, en-us, en
MIME-Version: 1.0
To: Robert Schwebel <r.schwebel@pengutronix.de>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de
Subject: Re: Identifying Intel Atom Z500PT
References: <20090407222144.GU5367@pengutronix.de>
In-Reply-To: <20090407222144.GU5367@pengutronix.de>
X-Enigmail-Version: 0.91.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Robert Schwebel wrote:
> Does anyone have an idea how to properly identify an Atom Z500PT cpu?
> The get_model_name() mechanics in arch/x86/kernel/cpu/common.c uses
> cpuid() to find out about the brand id, which is "Genuine Intel(R) CPU"
> with family 6 and model 28.

Family 6, model 28, stepping 2 seems to be common to all current Atoms
-- my 330 reports the same. There are some flags, however, that
currently only appear in the Z series, e.g. vmx is not available on the
230/330/N270. To differentiate between the latter, you could look for
64-bit support (which is missing in the N270) and the number of cores.
Besides that, the 230/330 models lack the speedstep feature.

I don't know if there's a way to distinguish a -P model from a -PT
model. But from a software point of view, they should be identical anyway.

> Below is the output of /proc/cpuinfo on that box:
> 
> root@phyCORE:~ cat /proc/cpuinfo | grep model | head -n 2
> model           : 28
> model name      : Genuine Intel(R) CPU        @ 1.10GHz

Strange - the 330 reports:

model name      : Intel(R) Atom(TM) CPU  330   @ 1.60GHz

(running 2.6.29).

-- 
Michael "Tired" Riepe <michael.riepe@googlemail.com>
X-Tired: Each morning I get up I die a little
