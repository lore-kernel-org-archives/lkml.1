Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbZGLVKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbZGLVKa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 17:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbZGLVKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 17:10:20 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:29150 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbZGLVKT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 17:10:19 -0400
MIME-Version: 1.0
Message-ID: <d05df0b0-e932-4525-8c9e-93f6cb792903@default>
Date: Sun, 12 Jul 2009 14:08:36 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Avi Kivity <avi@redhat.com>
Cc: npiggin@suse.de, akpm@osdl.org, jeremy@goop.org,
       xen-devel@lists.xensource.com, tmem-devel@oss.oracle.com,
       kurt.hackel@oracle.com, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, dave.mccracken@oracle.com,
       linux-mm@kvack.org, sunil.mushran@oracle.com, alan@lxorguk.ukuu.org.uk,
       Anthony Liguori <anthony@codemonkey.ws>,
       Schwidefsky <schwidefsky@de.ibm.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, chris.mason@oracle.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: RE: [Xen-devel] Re: [RFC PATCH 0/4] (Take 2): transcendent memory
 ("tmem") for Linux
In-Reply-To: <4A5A4AF2.40609@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.2  (306040) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.4A5A510C.005D:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Right, the transient uses of tmem when applied to disk objects
> >> (swap/pagecache) are very similar to disk caches.  Which is
> >> why you can
> >> get a very similar effect when caching your virtual disks;
> >> this can be
> >> done without any guest modification.
> >
> > Write-through backing and virtual disk cacheing offer a
> > similar effect, but it is far from the same.
> 
> Can you explain how it differs for the swap case?  Maybe I don't 
> understand how tmem preswap works.

The key differences I see are the "please may I store something"
API and the fact that the reply (yes or no) can vary across time
depending on the state of the collective of guests.  Virtual
disk cacheing requires the host to always say yes and always
deliver persistence.  I can see that this is less of a concern
for KVM because the host can swap... though doesn't this hide
information from the guest and potentially have split-brain
swapping issues?

(thanks for the great discussion so far... going offline mostly now
for a few days)

Dan
