Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbYC2ARg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbYC2ARg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 20:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641AbYC2AR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 20:17:28 -0400
Received: from smtp.ono.com ([62.42.230.12]:6534 "EHLO resmaa03.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753629AbYC2AR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 20:17:27 -0400
Date: Sat, 29 Mar 2008 01:16:56 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Ketil Froyn <ketil@froyn.name>
Cc: linux-kernel@vger.kernel.org
Subject: Re: unexpected rename() behaviour
Message-ID: <20080329011656.7c38265a@werewolf>
In-Reply-To: <47ED8858.9000401@froyn.name>
References: <47ED8858.9000401@froyn.name>
X-Mailer: Claws Mail 3.3.1cvs44 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Mar 2008 01:07:52 +0100, Ketil Froyn <ketil@froyn.name> wrote:

> Hi,
> 
> The following behaviour was unexpected (tested on Debian/ext3):
> 
> $ echo 1 > 1
> $ ln 1 2
> $ cat 2
> 1
> $ ./rename 2 1
> $ echo $?
> 0
> $ cat 2
> 1
> 
> The code for ./rename is simple:
> 
> ---
> /* compile: gcc -o rename rename.c */
> #include <stdio.h>
> int main(int argc, char *argv[]) { return rename(argv[1], argv[2]); }
> ---
> 
> I thought this must be wrong behaviour, but I have been unable to 
> confirm what the correct result should be in this special case. rename() 
> returns success, but the source file is intact, which seems odd. The 
> "mv" command specifically checks for cases like this and calls 
> unlink("2") instead of rename("2", "1"). Are all applications meant to 
> do this? What standards describe what rename() should do in cases like this?
> 

man 2 rename:

       If  oldpath  and  newpath are existing hard links referring to the same
       file, then rename() does nothing, and returns a success status.

That's why mv checks the special case.

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam05 (gcc 4.2.2 20071128 (4.2.2-2mdv2008.1)) SMP PREEMPT
