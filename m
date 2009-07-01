Return-Path: <linux-kernel-owner+w=401wt.eu-S1752214AbZGAXEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbZGAXEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 19:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbZGAXD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 19:03:58 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:35138 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbZGAXD5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 19:03:57 -0400
MIME-Version: 1.0
Message-ID: <79a405e4-3c4c-4194-aed4-a3832c6c5d6e@default>
Date: Wed, 1 Jul 2009 16:02:38 -0700 (PDT)
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
       Himanshu Raj <rhim@microsoft.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>
Subject: RE: [RFC] transcendent memory for Linux
In-Reply-To: <4A4A95D8.6020708@goop.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.2  (306040) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.4A4BEB2C.0013:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Jeremy Fitzhardinge [mailto:jeremy@goop.org]
> On 06/30/09 14:21, Dan Magenheimer wrote:
> > No, the uuid can't be verified.  Tmem gives no indication
> > as to whether a newly-created pool is already in use (shared)
> > by another guest.  So without both the 128-bit uuid and an
> > already-in-use 64-bit object id and 32-bit page index, no data
> > is readable or writable by the attacker.
> 
> You have to consider things like timing attacks as well (for 
> example, a
> tmem hypercall might return faster if the uuid already exists).
> 
> Besides, you can tell whether a uuid exists, by at least a couple of
> mechanisms (from a quick read of the source, so I might have 
> overlooked something):

All of these still require a large number of guesses
across a 128-bit space of possible uuids, right?
It should be easy to implement "guess limits" in xen
that disable tmem use by a guest if it fails too many guesses.
I'm a bit more worried about:

> You also have to consider the case of a domain which was once part of
> the ocfs cluster, but now is not - it may still know the uuid, but not
> be otherwise allowed to use the cluster.

But on the other hand, the security model here can be that
if a trusted entity becomes untrusted, you have to change
the locks.

> Yeah, a shared namespace of accessible objects is an entirely 
> new thing
> in the Xen universe.  I would also drop Xen support until 
> there's a good
> security story about how they can be used.

While I agree that the security is not bulletproof, I wonder
if this position might be a bit extreme.  Certainly, the NSA
should not turn on tmem in a cluster, but that doesn't mean that
nobody should be allowed to.  I really suspect that there are
less costly / more rewarding attack vectors at several layers
in the hardware/software stack of most clusters.

Dan
