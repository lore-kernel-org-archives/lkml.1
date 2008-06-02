Return-Path: <linux-kernel-owner+w=401wt.eu-S1758859AbYFBNpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859AbYFBNpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbYFBNpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:45:34 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:48721 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbYFBNpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:45:34 -0400
Message-Id: <20080602134438.224352910@theryb.frec.bull.fr>
User-Agent: quilt/0.46-1
Date: Mon, 02 Jun 2008 15:44:38 +0200
From: Benjamin Thery <benjamin.thery@bull.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Eric Biederman <ebiederm@xmission.com>, Serge Hallyn <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Al Viro <viro@ftp.linux.org.uk>, Daniel Lezcano <dlezcano@fr.ibm.com>,
       Benjamin Thery <benjamin.thery@bull.net>
Subject: [PATCH 00/10] sysfs tagged directories V4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is an updated version of Eric Biederman's patchset to implement
tagged directories in sysfs ported on top of 2.6.26-rc2-mm1.

Andrew,
Can you consider merging this patchset in -mm until gregkh has time 
to re-review it and take it (or reject it)?
We think having it in -mm, could be good for wider testing of this
proposed new feature in sysfs.

Thanks,
Benjamin

--

With the introduction of network namespaces, there can be duplicate 
network interface names on the same machine. Indeed, two network 
interfaces can have the same name if they reside in different network
namespaces. 

* Network interfaces names show up in sysfs.
* Today there is nothing in sysfs that is currently per namespace.
* Therefore we need to support multiple mounts of sysfs each showing a 
  different network namespace.

We introduce tagged directories in sysfs for this purpose.

Of course the usefulness of this feature is not limited to network stuff:
Serge Hallyn wrote a patch to fix a similar issue with user namespaces based 
on this patchset. His patch is included at the end of the patchset.

Tested with and without SYSFS_DEPRECATED. No regression found so far.

Changelog
---------
* V4:
  - Ported to 2.6.26-rc2-mm1
  - Updated patch for user namespace by Serge Hallyn (patch 10).
* V3:
  - Removed patch 10 ("avoid kobject name conflict with different 
    namespaces"), a better one was provided by Eric.
  - Removed patch 11 ("sysfs: user namespaces: add ns to user_struct"),
    Serge needs to rework some parts of it.
  - Change Acked-by: to Signed-off-by:, someone told me it is more 
    appropriate (as I'm in the delivery path).


Here is the announcement Eric wrote back in December to introduce his 
patchset:

"
Now that we have network namespace support merged it is time to
revisit the sysfs support so we can remove the dependency on !SYSFS.
[...]
The bulk of the patches are the changes to allow multiple sysfs
superblocks.

Then comes the tagged directory sysfs support which uses information
captured at mount time to decide which object with which tag will
appear in a directory.

Then the support for renaming and deleting objects where the source
may be ambiguous because of tagging.

Then finally the network namespace support so it is clear how all
of this tied together.
"

Regards,
Benjamin

-- 
