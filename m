Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571AbZDKE7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbZDKE7F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 00:59:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbZDKE6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 00:58:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:14113 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbZDKE6x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 00:58:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nmb9ylGztEMqxJATrRauymFrqyt65bNhQlFY2FYTnrMOFQSEw0JPF5KE4G/q+7b9yl
         BeB7+MfqLMXtlbwpR4JnRLNzuR1gdP4ZzV3rFthgfx5Xsj7M8dGtoFPTfue7r3yL+gmM
         pJX12TpzX/NdepxH+ArQhkR4kVO+4Ry01surI=
MIME-Version: 1.0
In-Reply-To: <900814656-1239422746-cardhu_decombobulator_blackberry.rim.net-2124207137-@bxe1152.bisx.prod.on.blackberry>
References: <E1Ls9pZ-0004IF-FZ@closure.thunk.org>
	 <20090410175723.GA20983@elf.ucw.cz> <200904102008.59932.rjw@sisk.pl>
	 <b6a2187b0904101812x270fbbc1i55918fd5ff98ccea@mail.gmail.com>
	 <900814656-1239422746-cardhu_decombobulator_blackberry.rim.net-2124207137-@bxe1152.bisx.prod.on.blackberry>
Date: Sat, 11 Apr 2009 12:58:52 +0800
Message-ID: <b6a2187b0904102158r5e37860cw2f45bee5578ebcf0@mail.gmail.com>
Subject: Re: suspend-to-ram broken on X61 thinkpads in 2.6.30-rc1?
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: tytso@mit.edu
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 12:04 PM, Theodore Tso <tytso@mit.edu> wrote:
> So I tried to do a bisect using a reduced config, and I wasn't able to reproduce.  So I went back to 2.6.30-rc1 and started playing with configurations.   I was able to finally get a reproduction, and I found that the af_packet module seems to be responsible.   If I move the modules directory out of the way and reboot, then manually insmod the af_packet module, then suspend, it fails by hanging with the flashing moon LED.  If I reboot and don't load the af_packet module, the suspend works.   Needless to say this falls into the WTF category.   I will do more testing to see what's up...

Latest linux git-pull seems to fix the problem. Suspend-to-ram and
resume now works. I've tried a few times and it works. Reverting the
patch makes it hang during suspend.

Latest git pull from 62b8e680e61d3f48f2a12ee248ca03ea8f376926 to
d848223808c5d21e1b3cea090047e34722c6254b

Thanks,
Jeff.
