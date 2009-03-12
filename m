Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbZCLALX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbZCLALX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 20:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbZCLALJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 20:11:09 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:62910 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbZCLALH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 20:11:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=srD0fON3Pt7DVzNEB2sS4u9ocI8aQkka+8+sCLjp4xfCtvXzbzBYVh4elmgDbSNU31
         eWSbhbjzQcYq3cn2lx2HZg7t92KylBAqQk2GMKnVgsL3iUhRSPZYOZ3px0z2FQ47wpSz
         5W2xiOTJVsokHO5w7N2xsxU6/crABbsDv2CA0=
Message-ID: <49B85312.5030905@gmail.com>
Date: Wed, 11 Mar 2009 18:10:58 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.ide,gmane.linux.kernel
To: n0diamond@yahoo.co.jp
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Off-by-one in both LIBATA and IDE drivers
References: <20090311082725.37cb1883@lxorguk.ukuu.org.uk> <20090311083846.5137.qmail@web4112.mail.ogk.yahoo.co.jp>
In-Reply-To: <20090311083846.5137.qmail@web4112.mail.ogk.yahoo.co.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Norman Diamond wrote:
> Alan Cox wrote:
>> Norman Diamond <n0diamond@yahoo.co.jp> wrote:
>>
>>> It looks like both LIBATA and the old IDE drivers
>>> have an off-by-one error in deciding whether to use
>>> READ SECTOR(S) instead of READ SECTOR(S) EXT.
>> This was fixed some time ago, you need a newer
>> kernel.
> 
> Well, either that or I need an older kernel.  It was also
> fixed in 2.6.20, for which I think there was a ready-made
> Slax distribution.
> 
> On another topic, trying 2.6.20 in whatever Slax
> distribution it was, an Intel ICH7M had DMA enabled on
> both /dev/hda and /dev/hdc.  I understand that the change
> which was made shortly after that is considered to be by
> design not a bug.  In 2.6.20 I didn't even have to type a
> "combined_mode" parameter, it just worked.  I understand
> that the addition and subsequent deletion of the
> "combined_mode" parameter are considered to be by design
> not bugs.  But it is not at all pleasant that my /dev/hda
> runs at 1.3 megabytes per second in 2.6.24.3 and later,
> when it used to run at 45 megabytes per second in 2.6.20. 
> Yeah I know libata is supposed to solve all this stuff. 
> Removed some bugs and added others.

You really shouldn't use the IDE drivers with SATA devices, if that's
what you're talking about as far as the previous behavior. They were
really never designed for it.

> 
> I can't go newer than 2.6.24.3 until I find a version
> where TASKFILEs start working again.  There might not be
> one.  Yeah I know libata is supposed to solve all this
> stuff.  I wonder how much time I'll need and how many
> varieties of hardware I'll have to buy to see if it's
> really fixed.

Realistically, although some people still work on it, testing coverage
of the old IDE drivers is not that great these days, since most
distributions no longer use it. The crusty, byzantine IDE code base
doesn't exactly make it easy for the inexperienced to debug problems,
either..
