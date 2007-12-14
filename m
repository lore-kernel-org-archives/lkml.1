Return-Path: <linux-kernel-owner+w=401wt.eu-S932606AbXLNNoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606AbXLNNoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 08:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbXLNNoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 08:44:05 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:64025 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbXLNNoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 08:44:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=xjILlVfw57WKz5pcyWO6zh/6CX7jrlC6MhAGUXe5/vdH5ORP/Vmdck/yS0wdLntPnOfJ1mfs0gcQhmsgQCNr7HK14wbWv578UqoArmDPh5U2dB9zwqP//K07g/ocFB7+qvwNrHUTZqfA+LuD/Hva61mwLU6HwH5Xx5Zfxgp29l4=
Message-ID: <47628842.5060908@keyaccess.nl>
Date: Fri, 14 Dec 2007 14:42:26 +0100
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <466F0941.9060201@reed.com> <1181682498.8176.224.camel@chaos> <469578CD.3080609@reed.com> <1184216528.12353.203.camel@chaos> <1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com> <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <20071214131502.GA14359@elte.hu>
In-Reply-To: <20071214131502.GA14359@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
From: Rene Herman <rene.herman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-12-07 14:15, Ingo Molnar wrote:

> wow, cool fix! (I remember that there were other systems as well that 
> are affected by port 0x80 muckery - i thought we had removed port 0x80 
> accesses long ago.)
> 
> how about the simpler fix below, as a first-level approach? We can then 
> remove the _p in/out sequences after this.

Your version does the same thing that the version from Pavel/David does for 
32-bit at least.

> +/*
> + * Some legacy devices need delays for IN/OUT sequences. Most are
> + * probably not needed but it's the safest to just do this short delay:
> + */
> +void native_io_delay(void)
> +{
> +	udelay(1);
> +}

Also note the thread(s) on LKML where 2 us was decided to be a nicely 
conservative value:

http://lkml.org/lkml/2007/12/12/309

Also see: http://lkml.org/lkml/2007/12/14/72

And also: http://lkml.org/lkml/2007/12/12/221

As such, please wait a bit for a fuller resolution. We're still discussing this.

Rene.
