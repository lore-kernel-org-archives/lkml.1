Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbYELL4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbYELL4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 07:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755962AbYELL4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 07:56:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:28864 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607AbYELL43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 07:56:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Fz2fTKv80jkQ/M/z38F/44SasILZRfUDT76WUptGv1SYwF7sVXFD3DacoYp0XgaglWhVmneAAbEbW2c6PDCwwhaWLk8zxNjbBETx7mOO1Wkw+9yMZ1yUGJQD+ckIbU2n4ZzU+s7raSP8+HoxuhimURhYPuBu5GwkppF8IGpnxwg=
Message-ID: <84144f020805120456r14436eend416e079ea88be9c@mail.gmail.com>
Date: Mon, 12 May 2008 14:56:28 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [RFC/PATCH] printk: detect incomplete lines
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Rob Landley" <rob@landley.net>
In-Reply-To: <20080512114925.GA29407@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080512114925.GA29407@damson.getinternet.no>
X-Google-Sender-Auth: c89f76fc58fd5bec
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 2:49 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>  This printk() problem has been bugging me for a long time. Consider the
>  following code:
>
>  diff --git a/init/main.c b/init/main.c
>  index ddada7a..777e02d 100644
>  --- a/init/main.c
>  +++ b/init/main.c
>  @@ -452,17 +452,38 @@ static void __init setup_command_line(char *command_line)
>   * gcc-3.4 accidentally inlines this function, so use noinline.
>   */
>
>  +static void printk_thread(const char *msg, unsigned long wait)
>  +{
>  +       int i = 0;
>  +
>  +       while(true) {
>  +               if (i == 0)
>  +                       printk(KERN_INFO "Here we go: ");
>  +
>  +               printk("%s%s", msg, i < 7 ? ", " : "\n");

You are supposed to use KERN_CONT here.
