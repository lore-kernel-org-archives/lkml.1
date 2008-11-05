Return-Path: <linux-kernel-owner+w=401wt.eu-S1756487AbYKERz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbYKERz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 12:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYKERzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 12:55:51 -0500
Received: from rv-out-0506.google.com ([209.85.198.232]:9424 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbYKERzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 12:55:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xozQLoaPwRKgYGX0Pmipayb61rg3TgcF1lC5Apsj73VlME0AEUNG9L+6TfgudghNI1
         D1innA8rT/UYFpll8zdCLB9/yq8k8mhtABrZcLIjFx9t33EAII1PfV4d8YnS/waLvL6Y
         MXEumAzXGLOdeB9aBtgfYXxcdCy1YXS1WEK8k=
Message-ID: <8bd0f97a0811050955k5fa31ccanc738b66348b83250@mail.gmail.com>
Date: Wed, 5 Nov 2008 12:55:49 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [PATCH] UIO: only call pgprot_noncached if defined
Cc: "Hans J. Koch" <hjk@linutronix.de>, "Mike Frysinger" <vapier@gentoo.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081105174234.GA10223@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225301177-21406-1-git-send-email-vapier@gentoo.org>
	 <20081105113610.GA6382@local> <20081105163334.GA8473@suse.de>
	 <8bd0f97a0811050933m13addb7eiddb963bfdf4d7416@mail.gmail.com>
	 <20081105174234.GA10223@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2008 at 12:42, Greg KH wrote:
> On Wed, Nov 05, 2008 at 12:33:37PM -0500, Mike Frysinger wrote:
>> On Wed, Nov 5, 2008 at 11:33, Greg KH wrote:
>> > On Wed, Nov 05, 2008 at 12:36:11PM +0100, Hans J. Koch wrote:
>> >> There seem to be archs that cannot easily implement a sensible
>> >> pgprot_noncached() function, so we should merge this patch. UIO doesn't
>> >> compile on these archs right now.
>> >
>> > No, we should fix those arches to have that function at least NULLed
>> > out.  Isn't there only one, Blackfin?  Putting #ifdefs in .c files is
>> > not something we really want to do if at all possible.
>>
>> that was my question.  this function isnt documented.  if the hardware
>> doesnt support it, is the right thing really for the arch to lie to
>> drivers and not actually give back cached settings even though it
>> asked for non-cached ?
>
> Probably not, it sounds like the arch needs to be fixed :)

i'd agree, but we're dealing with reality here: we're talking no-mmu
and we can not do caching on a per-page basis while maintaining
anything resembling usable performance.
-mike
