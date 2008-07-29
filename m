Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbYG2Qfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbYG2Qfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 12:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbYG2Qff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 12:35:35 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:28005 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbYG2Qfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 12:35:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=uwZpTo6oIQHcgxRE1AmXoiYa/ZpCR3KqH07BnzsH2vQZ7KmxTYmUsRhkgew2BmIEUA
         UGSrkLw2TJ0sqNIPkfcMquLAhsENUbsUy5nY+FXvluoGiSRy65u0VhIEh5T/7FhH4SAY
         W0IezUaS1GoMYn2CvGO/PMulErtuKTmDI3JCE=
Message-ID: <2c0942db0807290935s67eba63te5bb826a0ab7c752@mail.gmail.com>
Date: Tue, 29 Jul 2008 09:35:32 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: directory sort order no longer beginning with "." and ".."?
Cc: Oliver.Soltys@rsel.renesas.com, linux-kernel@vger.kernel.org
In-Reply-To: <488F2EDA.2090709@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <488EE7BF.4020908@rsel.renesas.com> <488F2EDA.2090709@goop.org>
X-Google-Sender-Auth: 8964f9957f84456a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 7:53 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Oliver Soltys wrote:
>>
>> My question: is this a bug, or a feature? I could not find anything about
>> that
>> anywhere...
>>
>> Does anybody have an idea, how I can fix this? Unfortunately, our
>> application
>> can not be changed.
>
> No Unix-like system makes any guarantee about the order of '.' and '..' with
> respect to other directory entries.  They've often appeared first as an
> implementation side-effect, but that's highly system and filesystem
> dependent.
>
> If you can't modify the app, you might consider some LD_PRELOAD library to
> replace readdir with something that sorts the results in the order your app
> expects.  There's already examples of that kind of thing to sort the results
> by inode.

That's a good idea, though based on his description it's even easier.
The LD_PRELOAD just needs to artificially introduce . and .., at the
beginning and toss them out once it hits them in the list. No sorting
required.
