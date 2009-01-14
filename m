Return-Path: <linux-kernel-owner+w=401wt.eu-S1764451AbZANQqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764451AbZANQqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 11:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764235AbZANQpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 11:45:47 -0500
Received: from adelie.canonical.com ([91.189.90.139]:41385 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764198AbZANQpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 11:45:43 -0500
Date: Wed, 14 Jan 2009 16:45:39 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: checkpatch confused by pre-existing #endif
Message-ID: <20090114164539.GD10653@shadowen.org>
References: <1231883863.21706.17.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231883863.21706.17.camel@dv>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 04:57:43PM -0500, Pavel Roskin wrote:
> Hello!
> 
> This patch confuses checkpatch.pl from Linux 2.6.29-rc1:
> 
> ====================
> --- foo.h.old	2009-01-13 16:48:22.000000000 -0500
> +++ foo.h	2009-01-13 16:48:18.000000000 -0500
> @@ -3,4 +3,8 @@
>  
>  
>  
> +#ifdef FOOBAR
> +#define foo
> +#endif
> +
>  #endif /* FOO_H */
> ====================
> 
> $ scripts/checkpatch.pl foo.diff 
> Can't use an undefined value as an ARRAY reference at
> scripts/checkpatch.pl line 453.
> 
> Apparently, the last #endif causes some data to be popped from the stack
> for preprocessor directives.  However, the corresponding #ifdef is
> outside the patch, so this fails.

Yes this should be fixed in the changes pushed up to Andrew.  You can
confirm this using the version here:

  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

-apw
