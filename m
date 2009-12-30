Return-Path: <linux-kernel-owner+w=401wt.eu-S1752716AbZL3RUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbZL3RUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 12:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbZL3RUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 12:20:32 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:40605 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbZL3RUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 12:20:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=UOTykEtiUH+x+HnI9SBkp6EzDP6WIV6ow66W+rRpV+cJGzGzV9SpozfaK/hZOb1I9u
         Oy7b1DEDMBTnqnc0GSY6TJ49Lz2eDpzsxKMngBpavksGQ2KABreSXVQKhRxpXrtd1oGE
         9nyr4j9hSuR2nmUz9JQRYhVEk0/dxMXPlT6Zw=
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-omap@vger.kernel.org, Helge Deller <deller@gmx.de>,
       rusty@rustcorp.com.au, akpm@linux-foundation.org, roland@redhat.com,
       dave@hiauly1.hia.nrc.ca, Parisc List <linux-parisc@vger.kernel.org>
Subject: Re: regression: crash from 'ls /sys/modules/wl1251_spi/notes'
References: <87k4w4wux9.fsf@purkki.valot.fi>
	<1262188157.2749.21.camel@mulgrave.site>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 30 Dec 2009 19:20:26 +0200
In-Reply-To: <1262188157.2749.21.camel@mulgrave.site> (James Bottomley's message of "Wed\, 30 Dec 2009 09\:49\:17 -0600")
Message-ID: <87d41wwf8l.fsf@purkki.valot.fi>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> writes:

> On Wed, 2009-12-30 at 13:41 +0200, Kalle Valo wrote:
>
>> Also removing wl1251_spi causes a crash. The reason for this is that a
>> sysfs file with a null string as name is trying to be removed from the
>> notes directory.
>
> Yes, this is because the notes sections describe the text sections.
> When we ignore an empty text section, we'd need to ignore its
> corresponding notes section.
>
> The reason we didn't see this on parisc is because our compiler doesn't
> actually produce any notes sections.

Also on omap not all modules can reproduce the problem. For example
cfg80211, mac80211 and wl1251 modules work just fine, but with
wl1251_spi I see the problem everytime.

> A better, and more comprehensive patch would be to try not to count the
> empty text sections when we're building the notes section (and actually
> anywhere else in the file).  This patch actually relies on the fact that
> if sh_size is zero for the text section it should be for the
> corresponding notes section.  If that doesn't work, we'd actually have
> to do the matching in the construction piece.
>
> Can you try it to see if it works for you?  If it doesn't, I'll try
> matching notes to text.  It works fine on parisc, but as we don't have a
> notes section, that's not saying much ...

Thanks. I tested the patch on my setup, this time on top of Linus'
tree (commit 6b7b284). And the patch fixes the issue, I can't
reproduce the problem at all, both 'rmmod wl1251_spi' and ls work
without any problems. So here's my tested-by:

Tested-by: Kalle Valo <kalle.valo@iki.fi>

Also please consider sending the fix to stable.

Thank you for fixing this so fast.

-- 
Kalle Valo
