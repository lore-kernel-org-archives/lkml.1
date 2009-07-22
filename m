Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbZGVOCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbZGVOCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 10:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbZGVOCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 10:02:10 -0400
Received: from d1.icnet.pl ([212.160.220.21]:52556 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755667AbZGVOCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 10:02:06 -0400
Message-ID: <4A671BC7.20300@tis.icnet.pl>
Date: Wed, 22 Jul 2009 16:01:43 +0200
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System
User-Agent: IceDove 1.5.0.14pre (X11/20080304)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: alsa-devel@alsa-project.org, Jonathan McDowell <noodles@earth.li>,
       Tony Lindgren <tony@atomide.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       e3-hacking@earth.li, Arun KS <arunks@mistralsolutions.com>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [alsa-devel] [RFC] [PATCH 1/3] ASoC: Add support for Conexant
 CX20442-11 voice modem codec
References: <200907220522.29221.jkrzyszt@tis.icnet.pl> <20090722101027.GA7622@sirena.org.uk>
In-Reply-To: <20090722101027.GA7622@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Mark Brown wrote:
> On Wed, Jul 22, 2009 at 05:22:28AM +0200, Janusz Krzysztofik wrote:
>> This patch adds support for Conexant CX20442-11 voice modem codec, suitable
>> for use by the ASoC board driver for Amstrad E3 (Delta) videophone. Related
>> sound card driver will follow.
>> ...
> This patch is basically fine from an ASoC point of view so I've applied
> it.

Thanks!

> You'll want to run checkpatch over it and send a followup fixing the

Sorry for not doing this before submitting. Will send the followup soon.

> issues it identifies.  Looking at this I suspect that it may be possible
> to refactor things so that more of the line discipline interaction is
> pushed down into the CODEC driver but that can also be done as a
> followup.

I have put the line discipline code into the machine driver for two reasons:
1. For me, the actual code is much more machine than codec specific.
2. It was much easier to update the codec structure instance with 
machine's provided hw_write() rather than fiddle with adding a new 
member to the structure definition for passing a machine callback to the 
line discipline functions.

If you think we can find any use cases for drivers supporting 
codec/modem combination other than CX20442 on Amstrad Delta, I can agree 
with you on moving the line discipline code out of the machine driver, 
but instead of pushing it down to the codec I would rather se it as a 
separate module.  Anyway, I think that some kind of support on the ASoC 
top level for this case could be helpfull.

> would also be nice to add some documentation somewhere explaining how
> the hw_write() function is expected to be set up since it's a little
> surprising (if the line discipline stuff were pushed down into the code
> that'd become a lot more obvious).

I'll add a few words to the followup.

Thanks,
Janusz
