Return-Path: <linux-kernel-owner+w=401wt.eu-S1756416Ab0AGAui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab0AGAui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 19:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756263Ab0AGAuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 19:50:37 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:53702 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756245Ab0AGAug convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 19:50:36 -0500
X-Greylist: delayed 1169 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jan 2010 19:50:36 EST
From: "Leyendecker, Robert" <Robert.Leyendecker@lsi.com>
To: Carsten Emde <Carsten.Emde@osadl.org>,
       Clark Williams <williams@redhat.com>
CC: John Kacur <jkacur@redhat.com>, RT <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Date: Wed, 6 Jan 2010 19:30:55 -0500
Subject: RE: [RFC] [rt-tests] change to cyclictest behavior
Thread-Topic: [RFC] [rt-tests] change to cyclictest behavior
Thread-Index: AcqPIs0RwfoGlVKXQYevTPgQ2PmEBgAADi3Q
Message-ID: <8C8865ED624BB94F8FE50259E2B5C5B30459433B48@palmail03.lsi.com>
References: <20100106130400.7f30ae55@torg>
	<520f0cf11001061139j2af13403qfcbf567647bdfaa8@mail.gmail.com>
	<4B4502FD.1000404@osadl.org>	<20100106160434.77efc790@torg>
	<4B450D91.7060403@osadl.org> <20100106162759.1d4d5b57@torg>
 <4B4513BA.5090001@osadl.org>
In-Reply-To: <4B4513BA.5090001@osadl.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Hmm, I think that this one is less obvious. Apparently, there are a
> bunch of different opinions on mlockall(). I once heard, for example,
> the opinion that mlockall() may - under some conditions - introduce a
> performance penalty, but I did not verify that. Many real-time systems
> do not have a "swap" line in /etc/fstab; mlockall() is not needed in
> such systems. In addition, most today's systems have so much RAM that
> swapping became a rather rare event. I hope some other RT-ers who are
> more knowledgeable about memory management and swapping can comment on
> this.
> 
> Cyclictest was in use for years, before someone introduced the -m
> option. I never used this option.
> 
> 	Carsten.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-
> users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


As rt user, I hope someone finds this useful-

I have found mlockall() necessary. I alloc very large buffers for transmitting and capturing hundreds of voip streams. In my testing, if I don't mlockall() mostly following the advice on the rt-wiki (thanks for this life saver) network rt performance is unacceptable, jitter is 10X - 50X worse on my system. File system activity renders the system choppy and sluggish. All my memory is nailed up and preloaded where possible before I pull the trigger. I run on standard FC distro (with most services turned off). Getting good performance on a standard distro is amazing to me.

Our test team has discovered that they get good network performance while simultaneously running wireshark and other apps like VNC. I think audio guys run huge x apps and full blown distros, while running 12+ channels of raw audio to disk. I can't see how they do it without mlock. Video would also seem to have severe memory requirements, where background tasks might be allowed to swap without serious impact to rt threads.

If rt-tests (or any app) isn't reading and writing big memory buffers, and not flushing cache and system is otherwise idle, I doubt mlock will make much difference in results even with standard distro using swap. For someone benchmarking using rt-tests while other apps are running or using standard distro seems like mlock option would be useful. 

Thanks for all the work here. It is greatly appreciated.

-Bob

