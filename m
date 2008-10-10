Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbYJJMPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbYJJMPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 08:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbYJJMPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 08:15:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:24892 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023AbYJJMPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 08:15:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=oQLUgML4YlP7N/xJy53UOvIMTnHiW4zlOWJ0dZph44I2kHlIqC4V3u6kKJNf1plFKQ
         zbMOJga4mHMYDXtRHuvMIFCxqkjT2M3YyVOCLncANcWaU33ZmpDSh3blvspEir5YDiJB
         83K21VH5/0TcMlwfrZ1hb0XyaCmetIgPxnH1A=
Message-ID: <cfd18e0f0810100515u6f510cbat880020bae14aee71@mail.gmail.com>
Date: Fri, 10 Oct 2008 14:15:23 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Bernd Petrovitsch" <bernd@firmix.at>
Subject: Re: dup2() vs dup3() inconsistency when
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Ulrich Drepper" <drepper@redhat.com>,
       "Al Viro" <viro@zeniv.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1223640571.8832.60.camel@spike.firmix.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0810090510i87f088fi9eeea829ae2b58c1@mail.gmail.com>
	 <48EE3D84.6000003@zytor.com> <48EE6A2B.8030005@redhat.com>
	 <48EE6CD6.10007@zytor.com> <48EE6F22.5070306@redhat.com>
	 <48EE703C.7070901@zytor.com>
	 <cfd18e0f0810092204n50f88887t7776133620eff75b@mail.gmail.com>
	 <1223640571.8832.60.camel@spike.firmix.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 2:09 PM, Bernd Petrovitsch <bernd@firmix.at> wrote:
> On Fri, 2008-10-10 at 07:04 +0200, Michael Kerrisk wrote:
> [....]
>> Well, as long as we are fixing the dup3() interface in the way that Al
>> and Ulrich have suggested, what about another fix:
>>
>> give an error if newfd is already open, thus forcing the user to do an
>> explicit close
>>
>> ?
>>
>> This silent close in dup2() is an implementation blemish.  Why not eliminate it?
>
> Apart from the usual "do not break almost all existing apps" killer
> reason: The alternative is that people will simply add a "close(newfd)"
> everytime before "dup2(oldfd,newfd)" since close() is harmless on a
> non-open fd.

Bernd,

I think you've missed the point.  The idea is not to change to dup2(),
but to eliminate the blemish in its design in the new dup3() (since we
have alrady eliminated one other blemish).

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
