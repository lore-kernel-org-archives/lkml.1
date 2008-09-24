Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbYIXXjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbYIXXjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 19:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbYIXXjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 19:39:43 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:3760 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbYIXXjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 19:39:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XjsgokHSJ9vOvnzGsFhTxunNLRaBzRyJPg53w8nKdOoo37t4CrUpBVR1F/m3n0AZaQ
         zXzEgWDmhxoMjOm1tCuSZDJqDAj+tJy0R7ruQl/NZMmxqCskZ+edciuc/7TyW3hbUrwm
         mObsMsw9qvpt2keIkLgLCNXpVHR3egw++2NWc=
Message-ID: <f7848160809241639hbe716c9q76b0e1b83d853721@mail.gmail.com>
Date: Wed, 24 Sep 2008 19:39:42 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [patch 00/04] RFC: Staging tree (drivers/staging)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Andreas Gruenbacher" <agruen@suse.de>,
       "Jeff Mahoney" <jeffm@suse.de>
In-Reply-To: <20080924230054.GA27730@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080924230054.GA27730@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 7:00 PM, Greg KH <gregkh@suse.de> wrote:
> So, does this all look good to everyone?  Any questions/issues?
>

I sure hope this does not end up like EXPERIMENTAL although it
essentially does duplicate the intent of EXPERIMENTAL.
(In other words - drivers live there for ever in staging mode, we
print warnings and generally nobody cares about the problem since the
kernel is tainted.)

That aside please at least substitute the word CRAP with something
better - like TAINT_NON_PRODUCTION or TAINT_UNRELIABLE or
TAINT_WORK_IN_PROGRESS or TAINT_EXPERIMENTAL . Arguably
TAINT_EXPERIMENTAL could also be used for known broken
CONFIG_EXPERIMENTAL items. It might also be better to change the
staging directory name to non-production or experimental - but that's
just my preference.

Also, I suppose it would be useful for Production machines to have a
kernel command line flag or something to say don't load staging
modules - for instance to prevent against automatic loading on drivers
from staging directory to support some oddball device etc.

Thinking more about it - could this whole thing not be achieved by
setting per module experimental flag and refusing to insmod'ing
experimental modules if -f was not specified. I believe force loading
also taints the kernel? All drivers intended for staging can set that
flag  - this way we don't need another TAINT flag and there is no need
for the directory name hack.

Parag
