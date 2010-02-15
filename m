Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab0BOLe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 06:34:58 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54541 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab0BOLe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 06:34:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EZU/7VdXTEj2yLcdemrin4GTWWDlRC8RNJ41jOlhJ3MVruMElzcvMSVd/jTE99Z50h
         N4GDLWKiRBMlokalPI0MhTF5/w0Y3bUsbs6yqqDK2YYgJ4DStM4a9U4od7BZjbVbC7oI
         LMQ6xKKZaFrmgjJD2wZ5VOWrkeyjwM61Fbxbw=
Date: Mon, 15 Feb 2010 19:37:30 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Adam Nielsen <a.nielsen@shikadi.net>
Cc: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: UML broken - runaway loop modprobe binfmt-464c
Message-ID: <20100215113730.GL12076@hack.private>
References: <4B78EE15.9020407@shikadi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B78EE15.9020407@shikadi.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 04:47:49PM +1000, Adam Nielsen wrote:
> Hi all,
>
> I've been forced to upgrade an old machine running a couple of UML VMs, 
> but I can't for the life of me figure out how to make them work on the 
> new machine.
>
> I've compiled the latest kernel from kernel.org with ARCH=um and when I 
> run it says this a few times and then stops:
>
> request_module: runaway loop modprobe binfmt-464c
>
> From Google it appears the cause of this is when you run a 64-bit system 
> with a 32-bit kernel, but I'm running a 64-bit kernel with a 32-bit 
> system.  I vaguely recall something about IA32 emulation in the normal 
> kernel build, but I can't see anything like that in the UML kernel 
> config.
>
> Does anyone know what might fix this?
>

So you are using 32-bit modprobe binary and 64-bit kernel?

This will not work, since kernel binfmt_elf module checks
if e_machine is EM_X86_64.

