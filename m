Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbZEZSeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbZEZSeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 14:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbZEZSeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 14:34:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:16709 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbZEZSeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 14:34:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LjdhdnW5NHqw6LjAc5Q54wI4Ps423Z/OwGzbZw3nLbmJx0KJhiK2sM9yA6pt3LNkct
         Or2kk/gLu+xFFXlJr3NkOkIMgjcehNqIcX9wJL2zc64/7r8guy/OdPmRhkGbermcGBcK
         1r8LsPLCNryOmQtrsayjL1SnpKYLH/nZ28HTI=
Date: Tue, 26 May 2009 22:34:05 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: akpm@linux-foundation.org, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, torvalds@linux-foundation.org
Subject: Re: [PATCH 17/38] groups: move code to kernel/groups.c
Message-ID: <20090526183405.GA11909@x200.localdomain>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com> <1242968132-1044-17-git-send-email-adobriyan@gmail.com> <20090526144819.GA21502@hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526144819.GA21502@hallyn.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 09:48:19AM -0500, Serge E. Hallyn wrote:
> Quoting Alexey Dobriyan (adobriyan@gmail.com):
> > Move supplementary groups implementation to kernel/groups.c .
> > kernel/sys.c already accumulated quite a few random stuff.
> > 
> > Do strictly copy/paste + add required headers to compile.
> > Compile-tested on many configs and archs.
> > 
> > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> 
> Actually I needed the following change:

This is dealt by first patch:
"[PATCH 01/38] cred: #include init.h in cred.h"
which is in -mm already.

> --- a/kernel/groups.c
> +++ b/kernel/groups.c
> @@ -1,6 +1,7 @@
>  /*
>   * Supplementary group IDs
>   */
> +#include <linux/init.h>

Wrong, groups.c doesn't use __init at all.
