Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbZHGH0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbZHGH0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 03:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbZHGH0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 03:26:35 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:64114 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168AbZHGH0f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 03:26:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UgEU/iYxWyGyUDL6RamagF4kTvYxw1c63zIW7niNEIkcNckCvzjn1eG1EZgATtsD8B
         /NhluQ3lq7Ga/qQqcUADota5sX1a00EAQk0FgVOW646TFUziP0uzjqjZzAc1WioxVrEu
         rlQaaoLVjJxOeGEL/3yttew12yyMhbFzVeudQ=
MIME-Version: 1.0
In-Reply-To: <adafxc4g1e7.fsf@cisco.com>
References: <e2e108260908060943u344bbe03k2baab01b204c9cca@mail.gmail.com>
	 <adad478hmi8.fsf@cisco.com>
	 <e2e108260908061146y47ae45f5j6b8085d44cd1c45b@mail.gmail.com>
	 <adaocqsg339.fsf@cisco.com>
	 <e2e108260908061229v2c605aabp7cf66cbe568d6755@mail.gmail.com>
	 <adafxc4g1e7.fsf@cisco.com>
Date: Fri, 7 Aug 2009 09:26:33 +0200
Message-ID: <e2e108260908070026s10658adl2c4a9a5b3eba1a08@mail.gmail.com>
Subject: Re: [ofa-general] IB kernel modules and the kobject release() method
From: Bart Van Assche <bart.vanassche@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: OpenIB <general@lists.openfabrics.org>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 6, 2009 at 9:58 PM, Roland Dreier<rdreier@cisco.com> wrote:
>
>  > Are you sure that this indicates a shortcoming in the kobject
>  > debugging code ? The most recent messages related to the message "does
>  > not have a release() function, it is broken and must be fixed" I could
>  > find on the LKML date from July 16, 2009
>  > (http://lkml.org/lkml/2009/7/16/306 and
>  > http://lkml.org/lkml/2009/7/16/391). As you can see Greg KH
>  > acknowledges that if this message is logged that this indicates a
>  > problem that should be fixed.
>
> I'm not sure -- I just assume that the core module unloading code is
> working OK, since it is so heavily tested.  If there were really a "must
> be fixed" problem with module unloading then someone would surely have
> hit more than a warning message.

(added Greg KH and the LKML in CC)

I tried to look up more information about kobjects. The comment of
commit 7a6a41615bfb2f03ce797bc24104c50b42c935e5 suggests that in the
past the function kobject_cleanup() did not free the memory allocated
for static kobject names but that this was the responsibility of the
release() function. This should have been fixed in the current version
of kobject_cleanup(). So I'm wondering whether the message that
kobjects that do not have a release() function are broken still makes
sense ?

See also
* http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7a6a41615bfb2f03ce797bc24104c50b42c935e5.
* http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.30.y.git;a=blob;f=lib/kobject.c

Bart.
