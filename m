Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbZFXLfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbZFXLfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 07:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755138AbZFXLfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 07:35:31 -0400
Received: from mail-yx0-f194.google.com ([209.85.210.194]:62976 "EHLO
	mail-yx0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263AbZFXLf3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:35:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=gHBV853Dm63R1T0OCCw6enHrpAslFVHyvft3YNHzlHpWkqfzIwnNdzbBGhznpFrMki
         GmrM0WedkVVrVnUta15zQbc+pxvnRWMUsDl7Iu+8uo8Phr1txHL0cgTAkRxxzzLfz392
         wQVtMLpmFuRRDetwEWE8Z178pPzF5uR1jZH/E=
MIME-Version: 1.0
In-Reply-To: <20090624043835.GM8633@ZenIV.linux.org.uk>
References: <1244959204-11269-1-git-send-email-vapier@gentoo.org> 
	<200906142214.40532.arnd@arndb.de> <20090624043835.GM8633@ZenIV.linux.org.uk>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 24 Jun 2009 07:35:12 -0400
Message-ID: <8bd0f97a0906240435w629c5fd9m352fde5060376b0f@mail.gmail.com>
Subject: Re: [PATCH 1/4] asm-generic: uaccess: do not expand args multiple 
	times
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 00:38, Al Viro wrote:
> On Sun, Jun 14, 2009 at 10:14:39PM +0200, Arnd Bergmann wrote:
>> On Sunday 14 June 2009, Mike Frysinger wrote:
>> > While it's debatable whether {get,put}_user() should be called with
>> > arguments that have side effects, macro's should be written safely in the
>> > first place.  In this case, a slightly off version of put_user() ended up
>> > causing random userspace corruption and these things aren't trivial to
>> > track down.
>> >
>> > While some of these conversions aren't strictly necessary, I think it's
>> > better to do all of them so as to be proactive in people accidently
>> > screwing it up in the future.
>>
>> I've tried this and failed. This change adds an endless number of sparse
>> warnings in put_user and even gcc warnings in get_user. The problem
>> is that typeof() carries over the 'const' and '__user' modifiers, both
>> of which prevent you from assigning data to the new pointer that you
>> constructed.
>>
>> I'd love to see a way to do this correctly, but this patch won't cut it.
>
> Note that sizeof(*(ptr)) does *NOT* evaluate ptr, unless we are dealing
> with variably-modified type.  The same goes for typeof.  And chk_user_ptr()
> expands to (void)0 during the build.

i never said it does -- i explicitly said i converted more than needed
on purpose

>  So I don't believe that existing variant
> is incorrect - we do not evaluate the argument twice.

except that it does.  read get_user() where the argument is expanded
once for access_ok() and twice when tailing to __get_user().  same
goes for put_user().
-mike
