Return-Path: <linux-kernel-owner+w=401wt.eu-S1751849AbZKOGhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbZKOGhe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 01:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbZKOGhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 01:37:34 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:65396 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbZKOGhd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 01:37:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=Z80pXDFwvRRg9XL5aWX5+pNbvV3zsGoDOpFgYlpoA88w4vv+sKPDXhui07wXaoOY/i
         tm6d8ig3B6gfcmn6jyJeH5fpONECl1qjjLdZVNFCP2NP0tvgCxnT3jKKS1i8iDKUlHzx
         Fyc5oJiHcjJpRKvwaBjeb2ezNsSsGeXLuZ3cI=
MIME-Version: 1.0
In-Reply-To: <20091108184722.GA1647@mit.edu>
References: <cover.1257602781.git.andre.goddard@gmail.com> 
	<7d5883637aa976b54e944998f635d47a41618a75.1257602781.git.andre.goddard@gmail.com> 
	<20091108184722.GA1647@mit.edu>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sun, 15 Nov 2009 04:37:19 -0200
Message-ID: <b8bf37780911142237v76025e5aia8a85fa01c2b5138@mail.gmail.com>
Subject: Re: [PATCH v4 12/12] tree-wide: convert open calls to remove spaces 
	to skip_spaces() lib function
To: Theodore Tso <tytso@mit.edu>, linux list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[trimmed very long cc: line]

On Sun, Nov 8, 2009 at 4:47 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Sat, Nov 07, 2009 at 01:16:20PM -0200, André Goddard Rosa wrote:
>> Makes use of skip_spaces() defined in lib/string.c for removing leading
>> spaces from strings all over the tree.
>>
>> Also, while at it, if we see (*str && isspace(*str)), we can be sure to
>> remove the first condition (*str) as the second one (isspace(*str)) also
>> evaluates to 0 whenever *str == 0, making it redundant. In other words,
>> "a char equals zero is never a space".
>
> There are a number of places that have the pattern of skipping
> whitespace, calling simpler_strtoul(), and then skipping whitespace
> afterwards.  And thinkpad_acpi.c and fs/ext4/super.c both have an
> indentical function, parse_strotul(), which basically does this plus
> doing actual error checking (a number of callers of simple_strtoul
> aren't checking to see if the user passed in a valid number or not,
> boo.)
>
> I would suggest that we should lift parse_strtoul() into lib/, both to
> save a bit of code, as well as encouraging people to do proper input
> validation, while we are doing this tree-wide cleanup.
>

Hi, Ted!

    I took a look at it but couldn't find use for it much besides the
ones you've
pointed out, so I'm not sure it really deserves a lib function. Most calls to
simple_strtoul() does not skips spaces.

Thanks,
André
