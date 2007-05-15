Return-Path: <linux-kernel-owner+w=401wt.eu-S1762347AbXEPNhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762347AbXEPNhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 09:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760583AbXEPNf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 09:35:59 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2079 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760759AbXEPNf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 09:35:56 -0400
Date: Tue, 15 May 2007 09:12:35 +0000
From: Pavel Machek <pavel@ucw.cz>
To: jjohansen@suse.de
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [AppArmor 37/45] AppArmor: Main Part
Message-ID: <20070515091235.GC6816@ucw.cz>
References: <20070514110607.549397248@suse.de> <20070514110620.908918667@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514110620.908918667@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The underlying functions by which the AppArmor LSM hooks are implemented.
> 
> Signed-off-by: John Johansen <jjohansen@suse.de>
> Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

> +#include "inline.h"

Select a better name for include?

> +static inline void aa_permerror2result(int perm_result, struct aa_audit *sa)

Betternameoffunction?

> +/**
> + * mangle -- escape special characters in str
> + * @str: string to escape
> + * @buffer: buffer containing str
> + *
> + * Escape special characters in @str, which is contained in @buffer. @str must
> + * be aligned to the end of the buffer, and the space between @buffer and @str
> + * may be used for escaping.
> + *
> + * Returns @str if no escaping was necessary, a pointer to the beginning of the
> + * escaped string, or NULL if there was not enough space in @buffer.  When
> + * called with a NULL buffer, the return value tells whether any escaping is
> + * necessary.
> + */
> +static const char *mangle(const char *str, char *buffer)
> +{
> +	static const char c_escape[] = {
> +		['\a'] = 'a',	['\b'] = 'b',
> +		['\f'] = 'f',	['\n'] = 'n',
> +		['\r'] = 'r',	['\t'] = 't',
> +		['\v'] = 'v',
> +		[' '] = ' ',	['\\'] = '\\',
> +	};
> +	const char *s;
> +	char *t, c;
> +
> +#define mangle_escape(c)						\
> +	unlikely((unsigned char)(c) < ARRAY_SIZE(c_escape) &&		\
> +		 c_escape[(unsigned char)c])
> +
> +	for (s = (char *)str; (c = *s) != '\0'; s++)
> +		if (mangle_escape(c))
> +			goto escape;
> +	return str;
> +
> +escape:
> +	if (!buffer)
> +		return NULL;
> +	for (s = str, t = buffer; (c = *s) != '\0'; s++) {
> +		if (mangle_escape(c)) {
> +			if (t == s)
> +				return NULL;
> +			*t++ = '\\';
> +			*t++ = c_escape[(unsigned char)c];
> +		} else
> +			*t++ = c;
> +	}
> +	*t++ = '\0';
> +
> +#undef mangle_escape
> +
> +	return buffer;
> +}

I do not think we want this in kernel.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
