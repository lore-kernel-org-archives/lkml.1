Return-Path: <linux-kernel-owner+w=401wt.eu-S934616AbXHHPRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934616AbXHHPRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 11:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757156AbXHHPRC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 11:17:02 -0400
Received: from jericho.provo.novell.com ([137.65.248.124]:46899 "EHLO
	jericho.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbXHHPRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 11:17:00 -0400
Message-ID: <46B9DE5E.7050406@suse.de>
Date: Thu, 09 Aug 2007 00:16:46 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Cornelia Huck <cornelia.huck@de.ibm.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, satyam@infradead.org,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 0/25] Sysfs cleanups & tagged directory support
References: <11860582832964-git-send-email-htejun@gmail.com>	<m1643rkqb6.fsf@ebiederm.dsl.xmission.com>	<20070808093815.0935a18e@gondolin.boeblingen.de.ibm.com>	<m1bqdifowo.fsf@ebiederm.dsl.xmission.com>	<20070808095432.4a520735@gondolin.boeblingen.de.ibm.com>	<m17io6foh8.fsf@ebiederm.dsl.xmission.com>	<20070808103759.0850383c@gondolin.boeblingen.de.ibm.com>	<20070808161631.1ccf27fd@gondolin.boeblingen.de.ibm.com>	<46B9D4B8.4050201@gmail.com>	<20070808165027.29af40b5@gondolin.boeblingen.de.ibm.com>	<46B9D961.4000902@gmail.com> <m1r6medpxl.fsf@ebiederm.dsl.xmission.com> <46B9DDA1.1080704@gmail.com>
In-Reply-To: <46B9DDA1.1080704@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Eric W. Biederman wrote:
>> Tejun Heo <htejun@gmail.com> writes:
>>
>>> Cornelia Huck wrote:
>>>> On Wed, 08 Aug 2007 23:35:36 +0900,
>>>> Tejun Heo <htejun@gmail.com> wrote:
>>>>
>>>>> Does the attached patch happen to fix the problem?
>>>> Indeed it does; thanks!
>>> Yeah, you seem to have 32bit off_t.  UINT_MAX overflows, so...
>> Weird.  And we have it opening the directory O_LARGEFILE.
>>
>> I have no problems with the fix though.
> 
> It's probably because of struct dirent definition used by readdir().

More specifically, d_off field.  It's a bit twisted.  For the last
entry, filp->f_pos gets written into the field and gets wrapped while
being copied out to userland or in glibc.

-- 
tejun
