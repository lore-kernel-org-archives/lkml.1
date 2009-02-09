Return-Path: <linux-kernel-owner+w=401wt.eu-S1756384AbZBIRow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbZBIRow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbZBIRon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:44:43 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:5175 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbZBIRom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:44:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N02xmCOhv1UY+1V57QLgzm5QCMAxMXW/tXotkiy9FDxUUCJZW9wMR6qq4QLos+re06
         dXP3C512ac+/Z0cRVj1zpfCBvmwGHSLHzMnEa8/icA9g5PUUta9C/A2tCpW+yTU8Ty1r
         1QV4TbekNTD4s6aM9PGQnVACTkwKLlrHXwp5g=
MIME-Version: 1.0
In-Reply-To: <20090209171042.GA19453@n2100.arm.linux.org.uk>
References: <8447d6730902090904y138af9c6r3d64278bc7a30811@mail.gmail.com>
	 <20090209171042.GA19453@n2100.arm.linux.org.uk>
Date: Mon, 9 Feb 2009 18:44:40 +0100
Message-ID: <8447d6730902090944s9bc96f7r76da82ea09c629f0@mail.gmail.com>
Subject: Re: [PATCH 1/2] User access to internal clocks
From: Davide Rizzo <elpa.rizzo@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, ben-linux@fluff.org,
       linux-api@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This driver is for user level programs to interact with system clocks.
>> It allows to read and modify rates and parents, using virtual files.
>> It requires the implementation of 2 additional functions in the clk interface:
>>  clk_for_each() and clk_name().
>> Actually I implemented that functions only for Samsung S3C24xx platform.
>
> NAK.
>
>> +       name = clk_get_name(clk);
>
> This implies that there is a 1:1 relationship between a 'name' and a
> struct clk.  No such thing exists (and where it does, it's being
> eliminated in ARM because it's just plain and simple WRONG.)
>
Not exactly, clk_get() could work in both way: a struct clk can be
exactly identified by name and device id (like clk_get is acting now)
or by full name, in the format clkname.device
Why do you say that it's wrong ? This is the same syntax used for
devices, why couldn't it be used also for clocks ? This should not
break backward compatibility.
May be clk_get_name() should be renamed as clk_get_full_name() ? Or it
would be better to make a function (or 2 different functions) that
returns separated name and device id ?
Otherwise, what do you suggest to enumerate and distinguish all system clocks ?
