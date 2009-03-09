Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbZCILEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbZCILEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 07:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbZCILEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 07:04:25 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:20638 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbZCILEZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 07:04:25 -0400
X-Greylist: delayed 546 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Mar 2009 07:04:24 EDT
X-IronPort-AV: E=Sophos;i="4.38,328,1233550800"; 
   d="scan'208";a="67557491"
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [alsa-devel] [PATCH 2/5] ASoC: ssm2602 codec: fix bug - kernelwill crash when record and play in bf527-ezkit
Date: Mon, 9 Mar 2009 19:07:26 +0800
Message-ID: <0F1B54C89D5F954D8535DB252AF412FA03AB85FE@chinexm1.ad.analog.com>
In-Reply-To: <20090306123515.GG6493@sirena.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [alsa-devel] [PATCH 2/5] ASoC: ssm2602 codec: fix bug - kernelwill crash when record and play in bf527-ezkit
Thread-Index: AcmeWAyDrAMdishjTS6VTWaC2SsP/gCTfI+Q
References: <1236326010-683-1-git-send-email-cooloney@kernel.org> <1236326010-683-3-git-send-email-cooloney@kernel.org> <20090306123515.GG6493@sirena.org.uk>
From: "Cai, Cliff" <Cliff.Cai@analog.com>
To: "Mark Brown" <broonie@sirena.org.uk>, "Bryan Wu" <cooloney@kernel.org>
Cc: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 09 Mar 2009 11:04:22.0829 (UTC) FILETIME=[CD6D7DD0:01C9A0A6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 This patch should be named :set constraint only if the value is not 0.
 I found that sometimes substream may be not NULL,but runtime can be
NULL,So the previous way will cause
Kernel to crash.

Cliff

>-----Original Message-----
>From: Mark Brown [mailto:broonie@sirena.org.uk] 
>Sent: Friday, March 06, 2009 8:35 PM
>To: Bryan Wu
>Cc: Cliff Cai; alsa-devel@alsa-project.org; 
>linux-kernel@vger.kernel.org
>Subject: Re: [alsa-devel] [PATCH 2/5] ASoC: ssm2602 codec: fix 
>bug - kernelwill crash when record and play in bf527-ezkit
>
>On Fri, Mar 06, 2009 at 03:53:27PM +0800, Bryan Wu wrote:
>
>> set constraint only if the value is not 0, change the 
>configuring way 
>> for sport
>
>This changelog doesn't appear to apply to this patch - it 
>looks like was copied from the previous one?  This patch 
>appears to suffer from a similar issue where only the first 
>format set by an application can ever be used, though since 
>this changes the constraints that are set by the driver 
>there's no possibility that applications will end up trying to 
>use a sample format that the hardware is not configured for.
>
>Do we really need such a heavy handed fix here - what is the 
>issue that's being fixed?
>
