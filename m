Return-Path: <linux-kernel-owner+w=401wt.eu-S1753491AbXKJRbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbXKJRbM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 12:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbXKJRa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 12:30:58 -0500
Received: from unthought.net ([212.97.129.88]:56558 "EHLO unthought.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbXKJRa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 12:30:57 -0500
X-Greylist: delayed 1499 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Nov 2007 12:30:57 EST
Date: Sat, 10 Nov 2007 18:05:57 +0100
From: Jakob Oestergaard <jakob@unthought.net>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, akpm@osdl.org, torvalds@osdl.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser(2)
Message-ID: <20071110170557.GA21977@unthought.net>
Mail-Followup-To: Jakob Oestergaard <jakob@unthought.net>,
	"Ahmed S. Darwish" <darwish.07@gmail.com>,
	Casey Schaufler <casey@schaufler-ca.com>, akpm@osdl.org,
	torvalds@osdl.org, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>
References: <472B8DAF.9080706@schaufler-ca.com> <20071103164303.GA26707@ubuntu> <20071105005625.GA18030@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071105005625.GA18030@ubuntu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

...
> I've double-checked the code for any possible off-by-one/overflow 
> errors.
...

Two things caught my eye.

...
> +		case bol:
> +		case subject:
> +			if (*label_len >= SMK_MAXLEN)
> +				goto out;
> +			subjectstr[(*label_len)++] = data[i];

Why is the '>' necessary?  Could it happen that you had incremented past the
point of equality?

If that could not happen, then in my oppinion '>=' is very misleading when '=='
is really what is needed.

...
> +		case object:
> +			if (*prevstate == blank) {
> +				subjectstr[*label_len] = '\0';
> +				*label_len = 0;
> +			}

I wonder why it is valid to uncritically use the already incremented label_len
here, without checking its value (like is done above).

It seems strangely asymmetrical. I'm not saying it's wrong, because there may
be a subtle reason as to why it's not, but if that's the case then I think that
subtle reason should be documented with a comment.

...
> +		case access:
> +			if (*prevstate == blank) {
> +				objectstr[*label_len] = '\0';
> +				*label_len = 0;
> +			}

Same applies here.


-- 

 / jakob

