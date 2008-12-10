Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYLJWhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYLJWhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 17:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbYLJWho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 17:37:44 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:3636 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbYLJWhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 17:37:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lCzkQ4FnuOybvm9Bhlf/B2zol5nX/vFeF99dB1RfgWwgksx6PkCr1vzHDR1Ih7EqOG
         Nw6aCNcmZdf9pABprUm7owEiwKIEFCdNFQNFhdLxbhcnm1QtZ3SwBCjMfAyJxn7SX2Ng
         kTI7pfYt3D5zYNl4J+KKvs5kDJLdFzXRwKAUw=
Message-ID: <8bd0f97a0812101437r4abb9346p8bc8d512ddc02cde@mail.gmail.com>
Date: Wed, 10 Dec 2008 17:37:42 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Vorobiev Dmitri" <dmitri.vorobiev@movial.fi>
Subject: Re: [PATCH 1/28] drivers/base/platform.c: Drop return value from platform_driver remove functions
Cc: "Julia Lawall" <julia@diku.dk>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <53806.88.114.236.15.1228947522.squirrel@webmail.movial.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0812101725540.21998@ask.diku.dk>
	 <8bd0f97a0812100928l2c75d373n7eba5aa0cc3882fd@mail.gmail.com>
	 <53806.88.114.236.15.1228947522.squirrel@webmail.movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 17:18, Vorobiev Dmitri wrote:
>> On Wed, Dec 10, 2008 at 11:26, Julia Lawall wrote:
>>> The return value of the remove function of a driver structure, and thus
>>> of
>>> a platform_driver structure, is ultimately ignored, and is thus
>>> unnecessary.  The goal of this patch is to make it possible to convert
>>> the
>>> platform_driver functions stored in the remove field such that they
>>> return
>>> void.  This patch introduces a temporary field remove_new with return
>>> type
>>> void into the platform_driver structure, and updates the only place that
>>> the remove function is called to call the function in the remove_new
>>> field,
>>> if one is available.  The subsequent patches update some drivers to use
>>> the
>>> remove_new field.
>>
>> why bother with remove -> remove_new convention ?
>
> Please see this email for the background:
>
> http://lkml.org/lkml/2008/12/10/231
>
>>  you'll get a
>> warning in C about the assignment, but you wont get a build failure,
>
> ...unless you compile with -Werror, which frequently the case.

anyone crazy enough to build with -Werror is crazy enough to send in a fix ;)
-mike
