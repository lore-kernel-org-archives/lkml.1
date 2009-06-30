Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbZF3VXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbZF3VXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbZF3VWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:22:54 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:34273 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbZF3VWx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:22:53 -0400
MIME-Version: 1.0
Message-ID: <c31ca108-9b68-40ba-936f-3ed2a56fd90b@default>
Date: Tue, 30 Jun 2009 14:21:35 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, npiggin@suse.de, chris.mason@oracle.com,
       kurt.hackel@oracle.com, dave.mccracken@oracle.com,
       Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
       alan@lxorguk.ukuu.org.uk, Rusty Russell <rusty@rustcorp.com.au>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, akpm@osdl.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, tmem-devel@oss.oracle.com,
       sunil.mushran@oracle.com, linux-mm@kvack.org,
       Himanshu Raj <rhim@microsoft.com>
Subject: RE: [RFC] transcendent memory for Linux
In-Reply-To: <4A493D19.4050908@goop.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.2  (306040) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.4A4A81F8.00BA:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Jeremy Fitzhardinge [mailto:jeremy@goop.org]
> On 06/29/09 14:57, Dan Magenheimer wrote:
> > Interesting question.  But, more than the 128-bit UUID must
> > be guessed... a valid 64-bit object id and a valid 32-bit
> > page index must also be guessed (though most instances of
> > the page index are small numbers so easy to guess).  Once
> > 192 bits are guessed though, yes, the pages could be viewed
> > and modified.  I suspect there are much more easily targeted
> > security holes in most data centers than guessing 192 (or
> > even 128) bits.
> 
> If its possible to verify the uuid is valid before trying to find a
> valid oid+page, then its much easier (since you can concentrate on the
> uuid first).

No, the uuid can't be verified.  Tmem gives no indication
as to whether a newly-created pool is already in use (shared)
by another guest.  So without both the 128-bit uuid and an
already-in-use 64-bit object id and 32-bit page index, no data
is readable or writable by the attacker.

> You also have to consider the case of a domain which was once part of
> the ocfs cluster, but now is not - it may still know the uuid, but not
> be otherwise allowed to use the cluster.
> If the uuid is derived from something like the
> filesystem's uuid - which wouldn't normally be considered sensitive
> information - then its not like its a search of the full 
> 128-bit space. 
> And even if it were secret, uuids are not generally 128 
> randomly chosen bits.

Hmmm... that is definitely a thornier problem.  I guess the
security angle definitely deserves more design.  But, again,
this affects only shared precache which is not intended
to part of the proposed initial tmem patchset, so this is a futures
issue.)

Thanks again for the feedback!
Dan
