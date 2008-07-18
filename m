Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbYGRDyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbYGRDyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 23:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbYGRDyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 23:54:11 -0400
Received: from ag-out-0708.google.com ([72.14.246.251]:15303 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbYGRDyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 23:54:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:sender;
        b=UHWB53Fsd1Gy8YtJ03u500XIyqJU2kDHgB4Njv0jRuBOBGjYe18phWpXkiQTyJgxWs
         M9nKBeOt+vp+9CxoiJX7syeLwrgwefxg3X4lVqPape87VKpPmET16PJBlGEEw75OV8t+
         jik9cQjoZ5aSpbZkXtupxA1hxSO9wbOnuNoqc=
Date: Fri, 18 Jul 2008 06:52:37 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: greg@kroah.com
Cc: torvalds@linux-foundation.org, Randy Dunlap <rdunlap@xenotime.net>,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: debugfs_create_u*() not SMP-safe
Message-ID: <20080718035237.GA7744@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed debugfs_create_u*() functions don't allow for any precautions
to be taken while doing r/w to the exported variables. Thus any export of a
variable isn't SMP-safe.

As far as I can tell, this only works safely for constant data. Let me
ask then, what is the purpose of these functions? Are they intended only
for unreliable data?

As I see it, they could be replaced by one of the following:
- Have them only export atomic data, that is atomic_t variables.
- Have them take a lock as a parameter, which the read() / write()
  handler grabs. The kernel code that exported the variable should also
  do r/w while holding that same lock.

Or am I wrong?


	Thanks,
	Eduard

