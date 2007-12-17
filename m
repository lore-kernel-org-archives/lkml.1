Return-Path: <linux-kernel-owner+w=401wt.eu-S1759123AbXLQS44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123AbXLQS44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 13:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937AbXLQS4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 13:56:48 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:34178 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbXLQS4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 13:56:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=s5GysvweLGsF3p6tknfpt7/JK2K76a82d7XPyAENuJwfPi7nhk9LOqbG8viEn4Ykvd8ktPBA+m8iTY+B6QN/KqSs9xPtuRbibdiW58zm2SoLNmJAfce7S240CUx3JPs23Hqevi5DezPWyyIz6OUx4mVdnYkgsoUVz02Al8DGlXI=
Message-ID: <4766C602.5050409@keyaccess.nl>
Date: Mon, 17 Dec 2007 19:54:58 +0100
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
CC: "David P. Reed" <dpreed@reed.com>, Avi Kivity <avi@qumranet.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Pavel Machek <pavel@ucw.cz>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <466F0941.9060201@reed.com> <1181682498.8176.224.camel@chaos>  <469578CD.3080609@reed.com>  <1184216528.12353.203.camel@chaos>  <1184218962.12353.209.camel@chaos>  <46964352.7040301@reed.com>  <1184253339.12353.223.camel@chaos>  <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <4762AA68.9030507@qumranet.com> <4763385E.9040106@reed.com> <Pine.LNX.4.61.0712171307150.4584@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.61.0712171307150.4584@chaos.analogic.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
From: Rene Herman <rene.herman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17-12-07 19:14, linux-os (Dick Johnson) wrote:

> Attached is a patch that changes the outs to ins on port 0x80.

No, that isn't useful. Only a write is "guaranteed" to make ISA/LPC meaning 
the timing for a read varies wildly. See the in/out cycles results posted 
earlier. Was also reading the Intel PIIX(3) chiset datasheet today which 
specifically mentions that only writes flow through to ISA, reads do not.

Rene.
