Return-Path: <linux-kernel-owner+w=401wt.eu-S1759340AbZDAPlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340AbZDAPlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 11:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbZDAPlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 11:41:37 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:55471 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbZDAPlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 11:41:36 -0400
X-RZG-AUTH: :LWIQcGC8af5qXkYNYt77sURZEFmV4M3TAgvB+Qeh4tE+44JfzNbYY5/NAUgO
X-RZG-CLASS-ID: mo05
Message-ID: <49D38B22.1050105@ursus.ath.cx>
Date: Wed, 01 Apr 2009 17:41:22 +0200
From: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: Dave Chinner <david@fromorbit.com>, Mark Lord <lkml@rtr.ca>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain>	 <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca>	 <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de>	 <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de>	 <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed>	 <1238417751.30488.12.camel@think.oraclecorp.com>	 <20090331235509.GU26138@disturbed> <1238590413.18549.7.camel@think.oraclecorp.com>
In-Reply-To: <1238590413.18549.7.camel@think.oraclecorp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01.04.2009 14:53 Chris Mason wrote:
> On Wed, 2009-04-01 at 10:55 +1100, Dave Chinner wrote:
>   
>> If you crash while rsync is running, then the state of the copy
>> is garbage anyway. You have to restart from scratch and rsync will
>> detect such failures and resync the file. gnome/kde have no
>> mechanism for such recovery.
>>     
> If this were the recovery system they had in mind, then why use rename
> at all?  They could just as easily overwrite the original in place.
>   

It is not a recovery system.  The renaming procedure is almost atomic
with e.g. reiser or ext3 (ordered), but simple overwriting would always
leave a window between truncating and the complete rewrite of the file.

> Using rename implies they want to replace the old with a complete new
> version.
>
> There's also the window where you crash after the rsync is done but
> before all the new data safely makes it into the replacement files.
>   

Sure, but in that case you have only lost some of your _mirrored_ data.
The original will usually be untouched by this. So after the restart you
just start the mirroring process again, and hopefully, this time you get
a perfect copy.

In KDE and lots of other apps the _original_ config files (and not any
copies) are "overlinked" with the new files by the rename. That's the
difference.

Andreas

