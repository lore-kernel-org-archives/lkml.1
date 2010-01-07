Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280Ab0AGHdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab0AGHdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 02:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343Ab0AGHdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 02:33:24 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:36584 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282Ab0AGHdX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 02:33:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fW1Wb3gBNY/0fqC61so1wpoocCB2AoewrKvUkqL84+Fig+sU4A+3FyBXK6AomzNlyt
         T/LyOSqJJ5gH2eiFJKePshBYAoqOTOfhvPWSIYjBjHuu0q2Qge8xEy3nENQOfa7sLxBc
         GHoSP348mH2kgZMB28SiZmuO8R/G+/2LMD38Q=
MIME-Version: 1.0
In-Reply-To: <adaeim2supb.fsf_-_@roland-alpha.cisco.com>
References: <ada3a2jugqu.fsf@roland-alpha.cisco.com>
	 <20100106123306.ac85e557.akpm@linux-foundation.org>
	 <aday6kbt14a.fsf@roland-alpha.cisco.com>
	 <20100106134232.0025e818.akpm@linux-foundation.org>
	 <adaeim2supb.fsf_-_@roland-alpha.cisco.com>
Date: Thu, 7 Jan 2010 08:33:21 +0100
X-Google-Sender-Auth: 0698bb67656b03c1
Message-ID: <e2e108261001062333p2a626bf6h4b25de0ac919ef1d@mail.gmail.com>
Subject: Re: [PATCH] Add BUILD_BUG_ON_NOT_POWER_OF_2()
From: Bart Van Assche <bvanassche@acm.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       David Dillow <dave@thedillows.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 7, 2010 at 12:02 AM, Roland Dreier <rdreier@cisco.com> wrote:
> +/* Force a compilation error if expression is not a power of 2 */
> +#define BUILD_BUG_ON_NOT_POWER_OF_2(n)                 \
> +       BUILD_BUG_ON(((n) != 0 && (((n) & ((n) - 1)) == 0)))

Hello Roland,

Can you please change the above into the following, such that the
macro does what its name suggests:

#define BUILD_BUG_ON_NOT_POWER_OF_2(n)                 \
       BUILD_BUG_ON(((n) == 0 || (((n) & ((n) - 1)) != 0)))

Bart.
