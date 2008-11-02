Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536AbYKBTcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbYKBTcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 14:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYKBTcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 14:32:11 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:16281 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbYKBTcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 14:32:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=wKseYlfJjRwvPGO2310D8LiFBOawsy0BjFTK808l3fM1gAL005NX7gIyn4vdx5sxlK
         wk5PVRccdqzJWPhxUUq9RPgNRIaTRoP+zQ58CUWrKT7WCYRgw9W2ze2dbs4SeJ2JSLBk
         IHo0sfepJsY6HbKH1aFO0DT5+YZU4pfoEJf1c=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Helge Deller <deller@gmx.de>
Subject: Re: [PATCH 1/1] USBHID: correct start/stop cycle
Date: Sun, 2 Nov 2008 20:24:31 +0100
User-Agent: KMail/1.8.2
Cc: Jiri Slaby <jirislaby@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
       Jeroen Roovers <jer@gentoo.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1225579306-28524-1-git-send-email-jirislaby@gmail.com> <490D873D.9010005@gmail.com> <490DDA69.4000404@gmx.de>
In-Reply-To: <490DDA69.4000404@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811022024.31528.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 November 2008 17:50, Helge Deller wrote:
> Jiri Slaby wrote:
> >>> btw. this is not expected to fix that, but if it does, the better ;).
> >> I tried the patch and sadly it didn't fixed the parisc bug.
> > 
> > Could you bisect it?
> 
> I fully bisected it, and the final "buggy" patch seems to have been 
> Denys Vlasenko's patch: cb8f488c33539f096580e202f5438a809195008f
> (see 
> http://github.com/jonsmirl/digispeaker/commit/cb8f488c33539f096580e202f5438a809195008f)
> Denys: Any reason you removed "!prev" in front of "expand_stack"?

Looks like I erroneously thought it can't be NULL,
or that expand_upwards() is ok with getting NULL vma parameter.

I looked again and neither is true.

Sorry, looks like I indeed broke this.
--
vda
