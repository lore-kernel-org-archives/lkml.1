Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbXDWGlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbXDWGlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 02:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbXDWGlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 02:41:22 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:33340 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbXDWGlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 02:41:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=miFfHlOA/+gony+CYMRU43RdCEb0WBqSyLa6uCY0rmp3h+Krty1qjFJdvQ1rKN7HIEGrz+KSOEgWxdw/xB34oOzFDmuWXhtrvOMZ89F4vSB470Sp/AkABIygvCOQBcAbmv/EUr4tnVOqze/6xjzjT+whH3GMAUpy+jo4GMmyRKo=
Message-ID: <462C54D5.6000101@gmail.com>
Date: Mon, 23 Apr 2007 15:40:21 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
References: <Pine.LNX.4.44L0.0704181032060.12246-100000@iolanthe.rowland.org>	 <46263A82.1030703@gmail.com>	 <d120d5000704180941pe2ab181xb5eab63b7cc1b297@mail.gmail.com>	 <20070419145133.2f7ed45a@gondolin.boeblingen.de.ibm.com>	 <d120d5000704190613h178ad644h53ad817db2950426@mail.gmail.com>	 <20070419154849.2e722762@gondolin.boeblingen.de.ibm.com>	 <d120d5000704190721u16be1110ufe04880eded7d54e@mail.gmail.com>	 <462856B9.9010307@gmail.com>	 <d120d5000704200935r2fb1e614m6da149eee0aec5b6@mail.gmail.com>	 <4628EFB2.9070709@gmail.com> <d120d5000704201059o750cc95am349707d353f79f10@mail.gmail.com>
In-Reply-To: <d120d5000704201059o750cc95am349707d353f79f10@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Dmitry.

Dmitry Torokhov wrote:
> Isn't think a good thing? By decoupling the 2 layers we insulate them
> from changes in each other. This allows bug subsystems to concentrate
> on topics that important to them instead of worying about refcounting
> objects that are not directly interesting for the subsystem in
> question.

I think the best thing would be make struct device's lifetime rules
simple enough such that it doesn't really matter to driver subsystems
and drivers can just do what they wanna do.

Also, separate struct device from the actual implementation has problem
in that struct device is widely used to refer to the device by many
layers drivers register devices to.  Basically, you'll have to implement
immediate-disconnect between struct device and the actual
implementation.  So, it just shifts the problem from struct device to
the place between struct device and actual implementation and I think
struct device itself is better place to deal with that than somewhere
inbetween it and driver private data.

> Now for smaller subsystems it may make sense to embed stuct devices
> into subsystem objects and manage it all together. In fact input
> system does this but I think it is much simlpier than SCSI or IDE.

Well, both SCSI and IDE heavily depend on struct device acting as 'base
class'.  It's all over the place and almost a basic assumption about the
driver model.

-- 
tejun
