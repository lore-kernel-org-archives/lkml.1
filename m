Return-Path: <linux-kernel-owner+w=401wt.eu-S935892AbXHHPOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935892AbXHHPOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 11:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760162AbXHHPNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 11:13:50 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:33966 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316AbXHHPNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 11:13:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=quPSADb5o4jzkRc3vu+ZLBhz23yEk/4fNsL/f4GLI2Ooo5RjDeVQAyZwtllgszbgWunEzdXM7xMVwhdQcCXL6b9KvD5RXoi05X5zzPey/fU9C/1kHD29meG9/PfTi3mwqbQStRm5R7qwmEvlZN2wkSpX5E6/7LrpKSC+hNRPtIU=
Message-ID: <46B9DDA1.1080704@gmail.com>
Date: Thu, 09 Aug 2007 00:13:37 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Cornelia Huck <cornelia.huck@de.ibm.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, satyam@infradead.org,
       stern@rowland.harvard.edu, Linux Containers <containers@lists.osdl.org>,
       gregkh@suse.de
Subject: Re: [PATCH 0/25] Sysfs cleanups & tagged directory support
References: <11860582832964-git-send-email-htejun@gmail.com>	<m1643rkqb6.fsf@ebiederm.dsl.xmission.com>	<20070808093815.0935a18e@gondolin.boeblingen.de.ibm.com>	<m1bqdifowo.fsf@ebiederm.dsl.xmission.com>	<20070808095432.4a520735@gondolin.boeblingen.de.ibm.com>	<m17io6foh8.fsf@ebiederm.dsl.xmission.com>	<20070808103759.0850383c@gondolin.boeblingen.de.ibm.com>	<20070808161631.1ccf27fd@gondolin.boeblingen.de.ibm.com>	<46B9D4B8.4050201@gmail.com>	<20070808165027.29af40b5@gondolin.boeblingen.de.ibm.com>	<46B9D961.4000902@gmail.com> <m1r6medpxl.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1r6medpxl.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Tejun Heo <htejun@gmail.com> writes:
> 
>> Cornelia Huck wrote:
>>> On Wed, 08 Aug 2007 23:35:36 +0900,
>>> Tejun Heo <htejun@gmail.com> wrote:
>>>
>>>> Does the attached patch happen to fix the problem?
>>> Indeed it does; thanks!
>> Yeah, you seem to have 32bit off_t.  UINT_MAX overflows, so...
> 
> Weird.  And we have it opening the directory O_LARGEFILE.
> 
> I have no problems with the fix though.

It's probably because of struct dirent definition used by readdir().  It
may differ depending on archs and glibc version but IIRC the backend
implementation of all directory listing functions in glibc were the
same.  It opens with O_LARGEFILE and use getdents64 to get full info
then clip it to whatever limit the called API imposes.

-- 
tejun
