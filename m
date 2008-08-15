Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbYHOKoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbYHOKoa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 06:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbYHOKoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 06:44:22 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:58898 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbYHOKoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 06:44:21 -0400
In-Reply-To: <48A55574.9070508@aitel.hist.no>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
       Arjan van de Ven <arjan@infradead.org>, Eric Paris <eparis@redhat.com>,
       greg@kroah.com, hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-kernel-owner@vger.kernel.org, malware-list@lists.printk.net,
       peterz@infradead.org, riel@redhat.com, tytso@mit.edu,
       viro@ZenIV.linux.org.uk
Subject: Re: TALPA - a threat model?  well sorta.
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: tvrtko.ursulin@sophos.com
Date: Fri, 15 Aug 2008 11:44:16 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 15/08/2008 11:44:16,
	Serialize by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 15/08/2008 11:44:16,
	Serialize complete at 15/08/2008 11:44:16,
	S/MIME Sign failed at 15/08/2008 11:44:16: The cryptographic key was not
 found,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 15/08/2008 11:44:17,
	Serialize complete at 15/08/2008 11:44:17
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080815104422.9D8812FE93F@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helge Hafting wrote on 15/08/2008 11:07:48:

> It seems to me that this "scan on file open" business is the
> wrong way to do things - because it reduces performance.

It can never be free - what ever you do it has to happen some time and 
that can and will clash with something else. So your reason why it is 
wrong is a bit to simplistic.

> If you scan on file open, then your security sw is too late and
> getting in the way.
>
> It is better to scan in advance. Most machines has lots of idle time.
> Use that time to scan in advance, and mark the files as "clean".
> 
> A "clean" file can be opened without further checking anytime - giving
> normal high performance.  A file that gets written to becomes "dirty"
> until checked again. Some mechanism for making a clean copy of a
> clean file might help avoid excessive "dirtying".
>
> "Scan on open" might still be useful for cases when the system
> haven't kept up with writing, but please don't aim to have
> this be the _primary_ mode of scanning. A file server
> where most of the stuff is pre-scanned will likely perform much better
> than  one scanning everything on open.

The first thing you have to make clear is whether in your vision inode 
clean-dirty-unknown status is persistent or not? But in any case I think 
you are making a problem where there isn't one, think about it a bit.

But the idea about the ability to make a clean copy is interesting. So we 
would need a copy done without userspace intervention and preserving the 
inode cache status alongside it. Maybe splice or tee could easily do it? 
Although I am not sure how often copying would happen and whether this 
would be such a gain.

--
Tvrtko A. Ursulin
Senior Software Engineer, Sophos

"Views and opinions expressed in this email are strictly those of the 
author.
 The contents has not been reviewed or approved by Sophos."
 

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

