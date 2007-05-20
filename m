Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbXETPWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbXETPWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 11:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756538AbXETPWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 11:22:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:2404 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482AbXETPWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 11:22:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=tb9k6yKAiEiu3xSEUWqmygGWqOmlNpyAQrwDOzvWPU2Z5a1e7mZ2YsM3ydMVB7JKz0zfI0UuNTxVR+fYl4M/cSPWoEmwbnvcat51xQiBt2TddWMkeP2ovktoOF22IeubgTXK5l/xr2/7SRmhSHvB17r3lH2HntWHg8m8JqtXVWk=
Message-ID: <2c0942db0705200822j685ec3b2x399a080622b6fc05@mail.gmail.com>
Date: Sun, 20 May 2007 08:22:07 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Al Viro" <viro@ftp.linux.org.uk>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
Cc: "Andrey Borzenkov" <arvidjaar@mail.ru>, "Uwe Bugla" <uwe.bugla@gmx.de>,
       "Ken Chen" <kenchen@google.com>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <20070520062816.GA4095@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <464F42F3.1080300@madrabbit.org>
	 <20070519191751.E51233A23A2@muan.mtu.ru>
	 <200705200124.13026.uwe.bugla@gmx.de>
	 <200705200845.43621.arvidjaar@mail.ru>
	 <2c0942db0705192316s2682807chd23df6f4de29edcb@mail.gmail.com>
	 <20070520062816.GA4095@ftp.linux.org.uk>
X-Google-Sender-Auth: 372cea4f1fbe5027
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/19/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> On Sat, May 19, 2007 at 11:16:59PM -0700, Ray Lee wrote:
> > Ken? Ball's in your court. As the patch isn't providing a killer
> > feature for 2.6.22, I'd suggest just reverting it for now until the
> > issues are ironed out.
>
> Hold it.  The real question here is which logics do we want there.
> IOW, and how many device nodes do we want to appear and _when_ do
> we want them to appear?

The when part is what looks to make it racy. I'm guessing that we're
relying on udev to create those loop nodes. If so, I think any scheme
that creates more on demand would give transient mount errors while
it's waiting on udev to create more nodes.

Perhaps if we were to start with 8 loop nodes at init (as we have in
2.6.21), and then always maintain a margin of 8 (or 4, or...) when
they start being used or detached?
