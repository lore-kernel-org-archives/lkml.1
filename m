Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbXFVThO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbXFVThO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 15:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbXFVThA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 15:37:00 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:61593 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbXFVTg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 15:36:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HJH1zW7mzIchuZl0ihDnhwrF+L3euNNxesxS9xehpB3v55reZ3oy3VlAyeGScnT7/CGnyR1C2O6zWxTNynUoW5mCCz31dM06+l8xTA7/L5Cc0RDMtNLV0QO7/bQxbScLJ/tFFD/CmId1vkjtyE4uiqXF3l4lxH+4EyNCWbkwNv0=
Message-ID: <a781481a0706221236t3b399afdkf2e07cb109fba226@mail.gmail.com>
Date: Sat, 23 Jun 2007 01:06:58 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Alexander Wuerstlein" <arw@arw.name>
Subject: Re: [PATCH] Check files' signatures before doing suid/sgid [2/4]
Cc: linux-kernel@vger.kernel.org,
       "Johannes Schlumberger" <spjsschl@stud.informatik.uni-erlangen.de>,
       linux-crypto@vger.kernel.org
In-Reply-To: <1182536729847-git-send-email-arw@arw.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070621155516.GA6838@faui01.informatik.uni-erlangen.de>
	 <1182536729847-git-send-email-arw@arw.name>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander, Johannes,

[ Added linux-crypto to Cc: ]

Wow, this is _one_ *intrusive* patchset indeed :-)

But first: Have you checked the digsig project? It's been doing
(for some time) what your current patchset proposes -- and
it uses public key cryptosystems for the key management,
which is decidedly better than using secret-keyed hashes
(HMAC, XCBC). Also, digsig aims to protect executable
binaries in general, and not just suid / sgid ones.

Second: Can we have some discussion on the security model /
threat model / trust model / cryptographic key management
scheme of your signing mechanism? [I had read through the
[0/4] mail you had sent yesterday, but found no relevant
discussion on these aspects there.]

>From the patchset, it appears you use a *common* secret key
for _all_ signed binaries, and it is set at kernel build-time itself:

On 6/22/07, Alexander Wuerstlein <arw@arw.name> wrote:
> sns_secret_key.dat contains the 'secret key' which is used for HMAC.

Where:

> --- /dev/null
> +++ b/security/sns_secret_key.dat
> +#define SNS_SECRET_KEY_SIZE 8
> +static char sns_secret_key[SNS_SECRET_KEY_SIZE] =
> +       {
> +               'd', 'e', 'a', 'd', 'b', 'e', 'e', 'f'
> +       };

[ Ok, I won't nitpick as to why does this file look like a header,
is #include-d in the C source as a header, but still has a .dat
extension :-) ]

Anyway, this is *totally* insecure and broken. Do you realize anybody
who lays hands on the kernel image can now _trivially_ extract the
should-have-been-a-secret key from it and use it to sign his own
binaries?

Satyam
