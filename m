Return-Path: <linux-kernel-owner+w=401wt.eu-S1754243Ab0A3XHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab0A3XHW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 18:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871Ab0A3XHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 18:07:21 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:65022 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab0A3XHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 18:07:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Nv8FML+b23SA5tVfInyKyYtudCAZWku08DgD59TEmxnKg81ntwgWZenttFeRMcjJ9v
         lIZcpaWzxlXzO+tuWYGsUEpq3OSqKj1Q2fi3zgItHLC2THb9V3xH7TGeh5qXnJ0YVfpX
         82wwSSYkdmfqLlPXx69CnCKJb5Bg2HOjFkc+g=
MIME-Version: 1.0
In-Reply-To: <201001302257.09354.arnd@arndb.de>
References: <1264800197-29523-1-git-send-email-cascardo@holoscopio.com>
	 <201001300741.20954.arnd@arndb.de>
	 <20100130072205.GA30378@core.coreip.homeip.net>
	 <201001302257.09354.arnd@arndb.de>
Date: Sun, 31 Jan 2010 00:07:18 +0100
Message-ID: <520f0cf11001301507k20e3cf8dqa73026e12f3a1767@mail.gmail.com>
Subject: Re: [PATCH] input: remove BKL from uinput open function
From: John Kacur <jkacur@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 30, 2010 at 10:57 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 30 January 2010, Dmitry Torokhov wrote:
>> On Sat, Jan 30, 2010 at 07:41:20AM +0100, Arnd Bergmann wrote:
>> > The change looks good, but the same driver also uses the BKL in the
>> > default_llseek function. It would be nice to get rid of that in the
>> > same patch, e.g. by adding a ".llseek = generic_file_llseek," line
>> > in the file_operations, or making it call nonseekable_open() if the
>> > driver does not require seek to do anything.
>> >
>>
>> I am afraid you mixed up the drivers, I don't see uinput implementing
>> seek...
>
> Sorry, I should have been clearer, but not implementing llseek
> is the problem I was referring to: When a driver has no explicit
> .llseek operation in its file operations and does not call
> nonseekable_open from its open operation, the VFS layer will
> implicitly use default_llseek, which takes the BKL. We're
> in the process of changing drivers not to do this, one by one
> so we can kill the BKL in the end.
>

I know we've discussed this before, but why wouldn't the following
make more sense?
 .llseek         = no_llseek,
