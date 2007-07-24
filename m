Return-Path: <linux-kernel-owner+w=401wt.eu-S1762235AbXGXUej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762235AbXGXUej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754909AbXGXUeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:34:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535AbXGXUeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:34:31 -0400
Message-ID: <46A6624E.60003@redhat.com>
Date: Tue, 24 Jul 2007 16:34:22 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ulrich Kunitz <kune@deine-taler.de>, linux-kernel@vger.kernel.org,
       honza@jikos.cz, jkosina@suse.cz
Subject: Re: Is PIE randomization breaking klibc binaries?
References: <20070720211300.GA21644@deine-taler.de> <46A131BF.4080404@zytor.com>
In-Reply-To: <46A131BF.4080404@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2007 06:05 PM, H. Peter Anvin wrote:
>> It looks like that the PIE randomization patch breaks klibc
>> binaries on x86-64.
>>
> 
> Interesting.
> 
> klibc binaries are indeed statically linked, but composed of two
> different ELF images: the application itself and the shared libary
> (which is referenced from the application header as the "interpreter").
>  Neither of these is an ET_DYN file; they are both ET_EXEC, so it
> *should* be unaffected by the PIE randomization patch.  Obviously, that
> seems to not be the case.
> 
> My guess is that this patch mishandles interpreter images which are
> ET_EXEC.  Jan, any insight?

Well, they don't run on Fedora 6 either (which has the same code, it's
part of exec-shield):

$ strace ./cat
execve("./cat", ["./cat"], [/* 55 vars */]) = -1 ENOENT (No such file or directory)
...
$ file cat
cat: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), statically linked (uses shared libs), stripped

Funny nobody noticed that before...
