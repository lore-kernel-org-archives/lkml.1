Return-Path: <linux-kernel-owner+w=401wt.eu-S1757893AbZCOKK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893AbZCOKK0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 06:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754368AbZCOKKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 06:10:14 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:39732 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbZCOKKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 06:10:13 -0400
Date: Sun, 15 Mar 2009 11:12:10 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29-rcx triviality - How to have foo.ko module with same name as foo.c source file
Message-ID: <20090315101210.GA5669@uranus.ravnborg.org>
References: <49BCD2F6.6030903@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BCD2F6.6030903@panasas.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 15, 2009 at 12:05:42PM +0200, Boaz Harrosh wrote:
> Since sometime in the 2.6.29-rc I'm no longer able to produce an
> out-of-tree module that has the same base-name as a source file.
> 
> This is what I had in 2.6.28:
> <Kbuild>
>     obj-m += foo.o
> </Kbuild>
> Where foo.c is a source file in the same directory.
> 
> But since 2.6.29-rcx it will no longer build my foo.ko module. I
> had to change it to:
> <Kbuild>
>     foo_mod-y = foo.o
>     obj-m += foo_mod.o
> </Kbuild>
> Which changed my module name in scripts and packages.

We use the single .c file for a module with the same name as the
module all over the kernel.

What is more likely is that your module started to include an
additional sourcefile (antoehr .o) in which case you no longer
can have a source file sharing the name of the module.

> P.S:
>   Just asking I realized that I can just add an "mv ..." command to my make file.

Using mv is no-no..

	Sam
