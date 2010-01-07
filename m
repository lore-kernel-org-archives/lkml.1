Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197Ab0AGHUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab0AGHUd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 02:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756111Ab0AGHUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 02:20:31 -0500
Received: from toro.web-alm.net ([62.245.132.31]:57032 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756097Ab0AGHU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 02:20:29 -0500
Message-ID: <4B4588C7.2040706@osadl.org>
Date: Thu, 07 Jan 2010 08:09:59 +0100
From: Carsten Emde <Carsten.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL) eG
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "Leyendecker, Robert" <Robert.Leyendecker@lsi.com>
CC: Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>,
       RT <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [rt-tests] change to cyclictest behavior
References: <20100106130400.7f30ae55@torg>	<520f0cf11001061139j2af13403qfcbf567647bdfaa8@mail.gmail.com>	<4B4502FD.1000404@osadl.org>	<20100106160434.77efc790@torg>	<4B450D91.7060403@osadl.org> <20100106162759.1d4d5b57@torg> <4B4513BA.5090001@osadl.org> <8C8865ED624BB94F8FE50259E2B5C5B30459433B48@palmail03.lsi.com>
In-Reply-To: <8C8865ED624BB94F8FE50259E2B5C5B30459433B48@palmail03.lsi.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2010 01:30 AM, Leyendecker, Robert wrote:

>>> How about -m (mlockall) as well?
>> Hmm, I think that this one is less obvious. Apparently, there are
>> a bunch of different opinions on mlockall(). I once heard, for
>> example, the opinion that mlockall() may - under some conditions -
>> introduce a performance penalty, but I did not verify that. Many
>> real-time systems do not have a "swap" line in /etc/fstab;
>> mlockall() is not needed in such systems. In addition, most today's
>> systems have so much RAM that swapping became a rather rare event.
>> I hope some other RT-ers who are more knowledgeable about memory
>> management and swapping can comment on this.
> I have found mlockall() necessary. I alloc very large buffers for
> transmitting and capturing hundreds of voip streams. In my testing,
> if I don't mlockall() mostly following the advice on the rt-wiki
> (thanks for this life saver) network rt performance is unacceptable,
> jitter is 10X - 50X worse on my system. File system activity renders
> the system choppy and sluggish. All my memory is nailed up and
> preloaded where possible before I pull the trigger. I run on standard
> FC distro (with most services turned off). Getting good performance
> on a standard distro is amazing to me.
> Our test team has discovered that they get good network performance
> while simultaneously running wireshark and other apps like VNC. I
> think audio guys run huge x apps and full blown distros, while
> running 12+ channels of raw audio to disk. I can't see how they do it
> without mlock.
> [..]
Yes, of course. No one wants to drop the -m option. It was only the
question whether we include it into the new -S (equals -a -t -n -d plus
same priority on all) option which would make it impossible to run -S
without -m. In case it is decided not to include -m, you would need to
specify it separately, such as, for example

  cyclictest -Sp99 -m

I would guess that this is acceptable, isn't it?

	Carsten.
