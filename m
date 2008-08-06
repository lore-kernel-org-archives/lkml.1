Return-Path: <linux-kernel-owner+w=401wt.eu-S1758060AbYHFPcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060AbYHFPcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbYHFPcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:32:15 -0400
Received: from brmea-mail-2.Sun.COM ([192.18.98.43]:43509 "EHLO
	brmea-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbYHFPcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:32:13 -0400
Date: Wed, 06 Aug 2008 07:31:47 -0400
From: David Collier-Brown <davecb@sun.com>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interfaceforon
 access scanning
In-reply-to: <e7d8f83e0808060657v6723510fma8ca6defbdbb65aa@mail.gmail.com>
To: Peter Dolding <oiaohm@gmail.com>
Cc: "Press, Jonathan" <Jonathan.Press@ca.com>, Rik van Riel <riel@redhat.com>,
       Greg KH <greg@kroah.com>, Arjan van de Ven <arjan@infradead.org>,
       Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Reply-to: davecb@sun.com
Message-id: <48998BA3.3080804@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
X-Accept-Language: en-us, en
References: <20080805103840.1aaa64a5@infradead.org>
 <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com>
 <20080805181141.GA10700@kroah.com>
 <2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com>
 <20080805205129.37d873f0@bree.surriel.com>
 <2629CC4E1D22A64593B02C43E855530304AE4AE3@USILMS12.ca.com>
 <e7d8f83e0808060538m361eca9xa349fe08fdb20f12@mail.gmail.com>
 <2629CC4E1D22A64593B02C43E855530304AE4AE6@USILMS12.ca.com>
 <e7d8f83e0808060657v6723510fma8ca6defbdbb65aa@mail.gmail.com>
User-Agent: Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.7) Gecko/20041221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Peter Dolding wrote:
 > My main issue is TALPA, dazuko and so on of Anti-Virus Filesystem
> monitoring are all going to break anyhow when
> http://lwn.net/Articles/251224/ Credentials get added and common
> filesystem caching gets added.
> 
> You want to change a permissions on a file/object before its opened.
> So does the Credential user space daemon on file systems that cannot
> store secuirty information.  We only really need 1 location in the
> source base for this.  Expand Credentials slightly to allow anti
> viruses to operate by by problem.   Even better when FS-Cache can sit
> on top of Credentials correctly no need for anti virus software to
> have independent caching of blocked and allowed files.  FS-Cache picks
> a large amount of this up.
> 
> Basically TALPA, dazuko and so on of Anti-Virus Filesystem monitoring
> don't fit in the future design of Linux.   All they will be is
> duplication of a existing interface.  A interface that complete avoids
> the stacking issue.

Then in a real sense you've solved much of their problem for them (;-))
After this comes engineering, so that they can re-use the scanning 
mechanisms they already have, but from a different caller.

The requirements are probably that they know
- is this an open for read or write (somewhat less time-sensitive)?
- is the data present, or do we have to wait?
- if so, for what?
as of the time they start looking at the file.  Having a race-free
mechanism using credentials and RCU is, IMHO, A Really Good Thing.

Another thing they and we will likely need is a way to discover
if a file is inacessable due to an AV operation, and if the time
it has been inacessable is less than or equal to a scanning
upper bound by file size or beyond it.  The latter is for repair
of broken state introduced by the AV process failing.

--dave

> 
> Peter Dolding
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
David Collier-Brown            | Always do right. This will gratify
Sun Microsystems, Toronto      | some people and astonish the rest
davecb@sun.com                 |                      -- Mark Twain
cell: (647) 833-9377, bridge: (877) 385-4099 code: 506 9191#
