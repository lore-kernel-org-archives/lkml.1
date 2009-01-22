Return-Path: <linux-kernel-owner+w=401wt.eu-S1759287AbZAVWhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287AbZAVWhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbZAVWho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:37:44 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:49229 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbZAVWhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:37:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=n2L0z+pe8jGFNF/iWQHHbVhETLTWL2B2ucNOEoEL3fIRd6/9xdx1XyRzpZAUfRo8+N
         NU4fUdwpcXLArNNQsX1MFCA+1nGR5/AZpwOeQvD98v+s2sXze2Vf7QZ8rJKTGdGXrqRH
         LRyb5MrMtFLciOFyjxX5dtLdHdludbhOurQvg=
MIME-Version: 1.0
In-Reply-To: <4978C812.90702@gmail.com>
References: <Pine.LNX.4.64.0901221205400.27341@melkki.cs.Helsinki.FI>
	 <20090122114237.GA13845@atrey.karlin.mff.cuni.cz>
	 <4978C812.90702@gmail.com>
Date: Fri, 23 Jan 2009 00:37:41 +0200
X-Google-Sender-Auth: 41f73cb5f7e7cc15
Message-ID: <84144f020901221437g68cba782wf20153783d296e6@mail.gmail.com>
Subject: Re: [PATCH] w35und: fix usb_control_msg() error handling in 
	wb35_probe()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Sandro Bonazzola <sandro.bonazzola@gmail.com>
Cc: Pavel Machek <pavel@suse.cz>, Greg Kroah-Hartman <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 9:25 PM, Sandro Bonazzola
<sandro.bonazzola@gmail.com> wrote:
> #  iwlist wlan0 scan
> wlan0     Interface doesn't support scanning.
>
> #  iwlist wmaster0 scan
> wmaster0  Interface doesn't support scanning.
>
> # ifconfig wlan0 10.0.4.1
> SIOCSIFADDR: No such device
> wlan0: ERROR while getting interface flags: No such device
>
> # ifconfig wmaster0 10.0.4.1
> SIOCSIFFLAGS: Operation not supported

Can you run that under strace? Looks to me like there indeed is a
wmaster0 device but there's something fishy going on how we initialize
it.
