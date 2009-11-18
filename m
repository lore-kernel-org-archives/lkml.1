Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbZKRKJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbZKRKJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 05:09:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbZKRKJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 05:09:13 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:42347 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbZKRKJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 05:09:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RweyBxZztrnbQcVF3PRqW0ygqsFCc6qPLOCJKB9ecjqw8MOltcj7HV+I45zBFGYaIW
         +l+0Ult9cz0MPyS33nGeXCOk+4XobPrHiyFndq/B+QFBZjIK6IeTK4vbiuICMVPcUf0u
         5UtleGjzhnmfHECxIOrULfqKlEigzzG2A4HjU=
MIME-Version: 1.0
In-Reply-To: <20091117125901.GF823@rakim.wolfsonmicro.main>
References: <ud43sjtaf.wl%morimoto.kuninori@renesas.com>
	 <20091109105858.GB1245@sirena.org.uk>
	 <20091109133136.GC1245@sirena.org.uk>
	 <20091116153000.GB29479@sirena.org.uk>
	 <aec7e5c30911170446n71031671i48aca11f5276405d@mail.gmail.com>
	 <20091117125901.GF823@rakim.wolfsonmicro.main>
Date: Wed, 18 Nov 2009 19:09:14 +0900
Message-ID: <aec7e5c30911180209x1981978es80db2dadf7dd8ef4@mail.gmail.com>
Subject: Re: Null suspend/resume functions
From: Magnus Damm <magnus.damm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Kuninori Morimoto <morimoto.kuninori@renesas.com>,
       alsa-devel@alsa-project.org, linux-pm@lists.linux-foundation.org,
       Magnus Damm <damm@opensource.se>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 9:59 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Nov 17, 2009 at 09:46:35PM +0900, Magnus Damm wrote:
>
>> On SuperH we have Runtime PM enabled on a few platforms together with
>> a few updated drivers. The latest driver to become more power aware is
>> this FSI driver.
>
> I understand exactly what the runtime PM stuff and the driver are doing
> here, the issue is the mandatory suspend and resume functions.

Cool, but don't you think it makes sense to see how other
architectures will deal with this first?

>> At this point the SuperH specific platform bus code requires the
>> callbacks ->runtime_suspend() and ->runtime_resume() to be present. It
>> may be a good idea to allow them to be NULL in the future or maybe
>> having some shared functions, but before starting to break out stuff
>> I'd like to see how other Runtime PM implementations deal with this.
>> So unless people object I prefer to keep it as-is for now.
>
> What is the reason for requiring that the driver provide stub functions?
> For me the issue is that if it's mandatory for the driver to provide the
> functions then having stub functions in there makes the driver look like
> it is abusing the API by not implementing mandatory functionality.

I see your point, but there is another side to it as well. Having the
stubs there is a way of showing that these functions may be called as
part of the Runtime PM management. Not having them would confuse
people even more IMO.

> Given that the arch is now dealing with clocking and power for the
> device using the runtime PM system it seems fairly clear that there are
> going to be drivers like this one that can at least skip the suspend
> part and may not need to do anything at resume time either.

Right. We just need to figure out what the arch-independent solution
would be, and we're unfortunately not there yet.

I can spend some time on updating the drivers and removing the
nop-stubs if you'd like, but I'd rather not since I suspect that I'll
have to update things again when we get Runtime PM for ARM or other
non-sh architectures.

Let me know what you think!

/ magnus
