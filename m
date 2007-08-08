Return-Path: <linux-kernel-owner+w=401wt.eu-S1761896AbXHHQDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761896AbXHHQDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756304AbXHHQDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:03:34 -0400
Received: from jericho.provo.novell.com ([137.65.248.124]:48403 "EHLO
	jericho.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245AbXHHQDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:03:33 -0400
Message-ID: <46B9E948.8080605@suse.de>
Date: Thu, 09 Aug 2007 01:03:20 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Cornelia Huck <cornelia.huck@de.ibm.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, satyam@infradead.org,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 0/25] Sysfs cleanups & tagged directory support
References: <11860582832964-git-send-email-htejun@gmail.com>	<m1643rkqb6.fsf@ebiederm.dsl.xmission.com>	<20070808093815.0935a18e@gondolin.boeblingen.de.ibm.com>	<m1bqdifowo.fsf@ebiederm.dsl.xmission.com>	<20070808095432.4a520735@gondolin.boeblingen.de.ibm.com>	<m17io6foh8.fsf@ebiederm.dsl.xmission.com>	<20070808103759.0850383c@gondolin.boeblingen.de.ibm.com>	<20070808161631.1ccf27fd@gondolin.boeblingen.de.ibm.com>	<46B9D4B8.4050201@gmail.com>	<20070808165027.29af40b5@gondolin.boeblingen.de.ibm.com>	<46B9D961.4000902@gmail.com>	<m1r6medpxl.fsf@ebiederm.dsl.xmission.com>	<46B9DDA1.1080704@gmail.com> <46B9DE5E.7050406@suse.de> <m11weednul.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m11weednul.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Eric W. Biederman wrote:
>> More specifically, d_off field.  It's a bit twisted.  For the last
>> entry, filp->f_pos gets written into the field and gets wrapped while
>> being copied out to userland or in glibc.
> 
> That could do it, and glibc is crunching it.  Oh well, it is
> easy enough to avoid as long as our inode numbers are small which
> the idr allocator seems to ensure.

Yeah, now I think about it.  glibc throws out entries which don't fit in
the data structure specified by the called API, so it probably threw out
the last entry which has UINT_MAX in d_off which doesn't fit in the
readdir() return structure.  Using INT_MAX should be just fine as IDA
always allocates the first empty slot.  We can add paranoia check in ino
allocation path.

-- 
tejun
