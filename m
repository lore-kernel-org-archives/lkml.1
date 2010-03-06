Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab0CFSUq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 13:20:46 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56675 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab0CFSUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 13:20:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=oEXuFCNI+eob+FsU3gh+JWK+rI0VPIPfByCYeXChaaJyiRjeFqsFcEh4iSgyn6d/pe
         EwFQxSErOR7oobAu0jWM6R2m9TK5R28p9Ytk9nCQsp80ixpk8eg7z+1u/vapC6IY5MDZ
         LRxGzwrS8rA9khs18tbgkmpVx2J3lWb0om4Mo=
Message-ID: <4B929CF9.8010506@gmail.com>
Date: Sat, 06 Mar 2010 10:20:41 -0800
From: walt <w41ter@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.3a3pre) Gecko/20100304 Shredder/3.2a1pre
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: "Switch !O_CREAT case to use of do_last()" causes segfault in
 glibc
References: <4B92944E.8080209@gmail.com> <20100306175917.GD30031@ZenIV.linux.org.uk> <20100306180313.GE30031@ZenIV.linux.org.uk>
In-Reply-To: <20100306180313.GE30031@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2010 10:03 AM, Al Viro wrote:

> _Really_ interesting; it doesn't look like an oops - smells like an attempt
> to do opendir() that fails for some reason, goes unnoticed and resulting
> FILE * (i.e. NULL) is fed to readdir()?
>
> What does it attempt to open?

Ah, this may help:

open("/usr/share/zoneinfo/", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 47
open("/usr/share/zoneinfo/MST7MDT", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 48
open("/usr/share/zoneinfo/MST7MDT/", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = -1 ENOTDIR (Not a directory)
--- SIGSEGV (Segmentation fault) @ 0 (0) ---
