Return-Path: <linux-kernel-owner+w=401wt.eu-S1759847AbYJVW01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759847AbYJVW01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 18:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYJVW0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 18:26:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:34869 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbYJVW0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 18:26:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=twDmVaX/+2u8/sApN9Nlofs7hILa0OHTs5IbSTgVaFLUK7DzBXjXTSkYSwfkdUeGs+
         k18RpXpl9FhYfzlLumxyK1Uo1c4BQC3F8TnroJdluJH5bue2HRuMChaLF1utbHyXcBYo
         LMvUqiX2ZOH6mWBEv4DxnFra7ztSmzHUsX1yk=
Message-ID: <d9def9db0810221526w5c95b6f1gb5a8de58eb6910a6@mail.gmail.com>
Date: Thu, 23 Oct 2008 00:26:15 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH 1/7] Adding empia base driver
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       em28xx <em28xx@mcentral.de>, acano@fastmail.fm,
       "Andre Kelmanson" <akelmanson@gmail.com>,
       "Bouwsma Barry" <freebeer.bouwsma@gmail.com>,
       "Dan Kreiser" <kreiser@informatik.hu-berlin.de>,
       "Frank Neuber" <fn@kernelport.de>,
       "Jelle de Jong" <jelledejong@powercraft.nl>,
       "John Stowers" <john.stowers.lists@gmail.com>,
       "Lukas Kuna" <lukas.kuna@evkanet.net>,
       "Stefan Vonolfen" <stefan.vonolfen@gmail.com>,
       "Stephan Berberig" <s.berberig@arcor.de>,
       "Thomas Giesecke" <thomas.giesecke@ibgmbh-naumburg.de>,
       "Vitaly Wool" <vwool@ru.mvista.com>, "Zhenyu Wang" <zhen78@gmail.com>
In-Reply-To: <d9def9db0810221524m738b838bs681c0b9159531c64@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0810221414w5348acf3re31a033ea7179462@mail.gmail.com>
	 <20081022220903.GA15278@kroah.com>
	 <d9def9db0810221524m738b838bs681c0b9159531c64@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 12:24 AM, Markus Rechberger
<mrechberger@gmail.com> wrote:
> On Thu, Oct 23, 2008 at 12:09 AM, Greg KH <greg@kroah.com> wrote:
>> On Wed, Oct 22, 2008 at 11:14:36PM +0200, Markus Rechberger wrote:
>>>     em2880-dvb:
>>>     * supporting the digital part of Empia based devices, which
>>> includes ATSC, ISDB-T and DVB-T
>>
>> <snip>
>>
>> Doesn't this driver duplicate some of the existing devices we already
>> support with the current in-kernel driver?  If so, why not just add the
>> new device support to the existing driver instead of duplicating
>> everything?
>>
>> This is going to cause a big problem for distros as they will not know
>> which to enable, so they will probably just disable this one, which is
>> what I don't think you want to have happen :(
>>
>
> the current driver doesn't support most devices which are in there,
> also the alsa
> audio driver can easily crash the whole system. (It's my code so I
> know what was wrong there).
>

since the USB IDs were taken from the driver from mcentral.de without
testing them at all.

> The core video code is already too much off, the VBI code added alot complexity
> to it it does frame slicing on the fly.
>
> Those devices ship VBI+VIDEO within 1 datastream, VBI and Video aren't
> that different
> in the system. both interfaces provide framebuffers through a mmap'ed interface.
> If all the VBI buffers are filled the data has to be sliced off in any
> case while providing
> the same bottom data ot the Video interface
>
> http://mcentral.de/hg/~mrec/em28xx-new/shortlog (there are more than
> 200 changelog entries
> what happened in detail).
>
> The development has been split off (first due limitations in the
> kernel, afterwards due ..., and finally
> due the restriction that all that has to work without a framework
> upgrade on the eeePC).
>
> diffing the 2 available drivers shows up that only the core is twice
> as big as the one which is currently
> in the driver (the result of 2-3 years asynchronous development).
>
> The driver is currently also tested with signal generators (different
> inputs, and different video standards).
>
> Very likely the best would be to replace the available driver with it
> but I don't care, alot people use and have been using the driver from
> mcentral.de for a long time, development has always been opensource
> there too.
>
> regards,
> Markus
>
