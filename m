Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbZHXVL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbZHXVL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 17:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZHXVL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 17:11:56 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:8599 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbZHXVLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 17:11:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VWmEpnCoiMKEOSkQmTE46zt8SFTqMIb/u+kM8WfcBwh2mKG0xgEcx1BpWvgBdTx+i7
         JnM6Grt5Of6K2IJGO24YQ6Jbqd7z5isgF9azzZ1EEXCKdiIrFHop8r0JFovlc3KP3Rwz
         PGQANg3iPVlfl4fBfPBShoXBQTQtBuQincJNw=
MIME-Version: 1.0
In-Reply-To: <20090824205209.GE29763@elf.ucw.cz>
References: <200903121413.04434.rob@landley.net>
	 <200903161426.24904.rob@landley.net>
	 <20090323104525.GA17969@elf.ucw.cz>
	 <87ljqn82zc.fsf@frosties.localdomain>
	 <20090824093143.GD25591@elf.ucw.cz> <82k50tjw7u.fsf@mid.bfk.de>
	 <20090824130125.GG23677@mit.edu> <20090824195159.GD29763@elf.ucw.cz>
	 <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz>
Date: Mon, 24 Aug 2009 17:11:56 -0400
Message-ID: <87f94c370908241411r45079c5cx3fc737cf4c3f7d1e@mail.gmail.com>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is 
	possible
From: Greg Freemyer <greg.freemyer@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ric Wheeler <rwheeler@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The papers show failures in "once a year" range. I have "twice a
> minute" failure scenario with flashdisks.
>
> Not sure how often "degraded raid5 breaks ext3 atomicity" would bite,
> but I bet it would be on "once a day" scale.
>

I agree it should be documented, but the ext3 atomicity issue is only
an issue on unexpected shutdown while the array is degraded.  I surely
hope most people running raid5 are not seeing that level of unexpected
shutdown, let along in a degraded array,

If they are, the atomicity issue pretty strongly says they should not
be using raid5 in that environment.  At least not for any filesystem I
know.  Having writes to LBA n corrupt LBA n+128 as an example is
pretty hard to design around from a fs perspective.

Greg
