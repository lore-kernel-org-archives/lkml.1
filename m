Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbYAPTHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbYAPTHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 14:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbYAPTGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 14:06:54 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45465 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbYAPTGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 14:06:53 -0500
In-Reply-To: <4d47a5d10801151724m418e18efp9a0dd936e9a3584c@mail.gmail.com>
To: "Daniel Phillips" <phillips@google.com>
Cc: "Al Boldi" <a1426z@gawab.com>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "David Chinner" <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       "Pavel Machek" <pavel@ucw.cz>, "Rik van Riel" <riel@redhat.com>,
       "Theodore Tso" <tytso@mit.edu>, "Valerie Henson" <val.henson@gmail.com>
MIME-Version: 1.0
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental fsck)
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OFDB679999.9793D1C7-ON882573D2.00646D05-882573D2.0068FF85@us.ibm.com>
From: Bryan Henderson <hbryan@us.ibm.com>
Date: Wed, 16 Jan 2008 11:06:50 -0800
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Release 8.0|August 02, 2007) at 01/16/2008
 14:06:51,
	Serialize complete at 01/16/2008 14:06:51
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>The "disk motor as a generator" tale may not be purely folklore.  When
>an IDE drive is not in writeback mode, something special needs to done
>to ensure the last write to media is not a scribble.

No it doesn't.  The last write _is_ a scribble.  Systems that make atomic 
updates to disk drives use a shadow update mechanism and write the master 
sector twice.  If the power fails in the middle of writing one, it will 
almost certainly be unreadable due to a CRC failure, and the other one 
will have either the old or new master block contents.

And I think there's a problem with drives that, upon sensing the 
unreadable sector, assign an alternate even though the sector is fine, and 
you eventually run out of spares.


Incidentally, while this primitive behavior applies to IDE (ATA et al) 
drives, that isn't the only thing people put filesystem on.  Many 
important filesystems go on higher level storage subsystems that contain 
IDE drives and cache memory and batteries.  A device like this _does_ make 
sure that all data that it says has been written is actually retrievable 
even if there's a subsequent power outage, even while giving the 
performance of writeback caching.

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Filesystems

