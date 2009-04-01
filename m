Return-Path: <linux-kernel-owner+w=401wt.eu-S932804AbZDAShi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804AbZDAShi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 14:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762833AbZDASh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 14:37:27 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:30488 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762296AbZDASh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 14:37:26 -0400
X-RZG-AUTH: :LWIQcGC8af5qXkYNYt77sURZEFmV4M3TAgvB+Qeh4tE+44JfzNbYY5/NAUgO
X-RZG-CLASS-ID: mo05
Message-ID: <49D3B45E.3050900@ursus.ath.cx>
Date: Wed, 01 Apr 2009 20:37:18 +0200
From: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Dave Chinner <david@fromorbit.com>, Mark Lord <lkml@rtr.ca>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain>	 <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca>	 <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de>	 <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de>	 <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed>	 <1238417751.30488.12.camel@think.oraclecorp.com>	 <20090331235509.GU26138@disturbed>	 <1238590413.18549.7.camel@think.oraclecorp.com>	 <49D38B22.1050105@ursus.ath.cx> <1238601746.18549.55.camel@think.oraclecorp.com>
In-Reply-To: <1238601746.18549.55.camel@think.oraclecorp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01.04.2009 18:02 Chris Mason wrote:
> On Wed, 2009-04-01 at 17:41 +0200, Andreas T.Auer wrote:
>   
>> On 01.04.2009 14:53 Chris Mason wrote:
>>     
>> It is not a recovery system.  The renaming procedure is almost atomic
>> with e.g. reiser or ext3 (ordered), but simple overwriting would always
>> leave a window between truncating and the complete rewrite of the file.
>>
>>     
>
> Well, we're considering a future where ext3 and reiser are no longer
> used, and applications are responsible for the flushing if they want
> renames atomic for data as well as metadata.
>   
As long as you only consider it, all will be fine ;-). As a user I don't
want to use a filesystem which leaves a long gap between renaming the
metadata and writing the data for it, that is having dirty, inconsistent
metadata overwriting clean metadata. So Ted's quick pragmatic approach
to patch it in the first step was good, even if it's possible that it's
not be the final solution.

Flushing in applications is not a suitable solution. Maybe barriers
could be a solution, but to get something like this into _all_ the
multitude of applications is very unlikely.
There might be filesystems which use a delayed, but ordered mode. They
could provide "atomic" renames, and perform much better, if applications
do not flush with every file update.

Andreas

