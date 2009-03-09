Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbZCILFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbZCILFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 07:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbZCILFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 07:05:04 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:49358 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbZCILFD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 07:05:03 -0400
X-IronPort-AV: E=Sophos;i="4.38,328,1233550800"; 
   d="scan'208";a="67557066"
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [alsa-devel] [PATCH 1/5] ASoC: Blackfin: fix bug - kernel willcrash when record and play in bf527-ezkit
Date: Mon, 9 Mar 2009 18:58:19 +0800
Message-ID: <0F1B54C89D5F954D8535DB252AF412FA03AB85F5@chinexm1.ad.analog.com>
In-Reply-To: <20090306120145.GF6493@sirena.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [alsa-devel] [PATCH 1/5] ASoC: Blackfin: fix bug - kernel willcrash when record and play in bf527-ezkit
Thread-Index: AcmeU1nWHkSK2+E2TkaVAWYWzFndUACUZsuw
References: <1236326010-683-1-git-send-email-cooloney@kernel.org> <1236326010-683-2-git-send-email-cooloney@kernel.org> <20090306120145.GF6493@sirena.org.uk>
From: "Cai, Cliff" <Cliff.Cai@analog.com>
To: "Mark Brown" <broonie@sirena.org.uk>, "Bryan Wu" <cooloney@kernel.org>
Cc: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 09 Mar 2009 10:55:15.0933 (UTC) FILETIME=[8773C8D0:01C9A0A5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
This patch should be named : change the configuring way for sport,
Because I found that the previous way is not reliable sometimes.
Application like "tone" ,will call starup() twice before entering
hw_params() to configure SPORT.  
in this case SPORT won't be configured at all.

Cliff

>-----Original Message-----
>From: Mark Brown [mailto:broonie@sirena.org.uk] 
>Sent: Friday, March 06, 2009 8:02 PM
>To: Bryan Wu
>Cc: Cliff Cai; alsa-devel@alsa-project.org; 
>linux-kernel@vger.kernel.org
>Subject: Re: [alsa-devel] [PATCH 1/5] ASoC: Blackfin: fix bug 
>- kernel willcrash when record and play in bf527-ezkit
>
>On Fri, Mar 06, 2009 at 03:53:26PM +0800, Bryan Wu wrote:
>> From: Cliff Cai <cliff.cai@analog.com>
>> 
>> set constraint only if the value is not 0, change the 
>configuring way 
>> for sport
>
>Hrm.  As far as I can tell the actual effect of this patch is 
>to not do any of the per-format configuration for the sport if 
>the sport has been configured once already - as far as I can 
>tell nothing ever resets your 'configured' variable and this 
>is the only place that the data format is taken into account.  
>Won't this mean that if a second data format is played the 
>audio will be mishandled since the hardware will not have been 
>configured for the new audio format?
>
>If it's really not possible to reconfigure the hardware (I'm 
>assuming that this is what the actual crash is?) I would 
>expect to see code added which remembers the format that has 
>been configured and then adds a constraint in the startup() 
>function enforcing that.
>
