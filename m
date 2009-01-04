Return-Path: <linux-kernel-owner+w=401wt.eu-S1757211AbZADKcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbZADKcx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 05:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbZADKcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 05:32:45 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:14543 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbZADKco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 05:32:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p0AouZYIY6E7rOgmW5Wur9e50CVt+O91TctsL4LuEZwVgI9FSkldmMj6v9vMt2dsjN
         fNNwNHU3Kq7jXzxJcVgkbeZ8ebup8TrrrXzMEX4h/84nMUgjXblZO8nvJoLCaPUDrMmr
         eJbksu6IYHJ4hOS20w97fFJ0Da+uQSxUVVF/U=
Date: Sun, 4 Jan 2009 13:32:39 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, david@lang.hm,
       LKML <linux-kernel@vger.kernel.org>, yhlu.kernel@gmail.com
Subject: Re: early exception error
Message-ID: <20090104103239.GA7632@localhost>
References: <20090102175226.GE5372@localhost> <alpine.DEB.1.10.0901021131210.21567@asgard.lang.hm> <20090102203058.GH5372@localhost> <alpine.DEB.1.10.0901030823190.23262@asgard.lang.hm> <20090103161052.GB11093@localhost> <alpine.DEB.1.10.0901031118450.23262@asgard.lang.hm> <20090103190316.GB7367@localhost> <20090103212426.GC7367@localhost> <496001A3.1040201@gmail.com> <20090104005904.GQ496@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090104005904.GQ496@one.firstfloor.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Andi Kleen - Sun, Jan 04, 2009 at 01:59:04AM +0100]
| > Hint: line 442 in 2.6.28 is
| > if (!bdata->node_bootmem_map)
| > ;)
| > 
| > It's:
| > 0xffffffff8096452a <alloc_bootmem_core+69>:     cmpq   $0x0,0x10(%rbp)
| > and hence cr2 is 10.
| > 
| > node_data[nid] is NULL... But both of them are set up. Maybe too high nid (and
| > pnum in sparse_init)?
| 
| I think it's because SRAT parsing failed and the fallback forget
| to clean some state. Or at least I thought that until numa=noacpi
| failed too (if it fails the same way that theory is not correct)
| 
| -Andi
| > 
| 
| -- 
| ak@linux.intel.com
| 

according to image David's machine fails the same
way for numa=noacpi (unfortunately).

Actually I found one bug in memory_present -- in
case of SLAB code being activated (which should
be later stage of booting so it's not our case
now) sparse_index_init could fail with -ENOMEM
and we'll try to deref NULL in further. I'm fixing
it now but again -- it's not the issue we have now.

To Jiri: good catch! :-)

		- Cyrill -
