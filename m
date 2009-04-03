Return-Path: <linux-kernel-owner+w=401wt.eu-S936415AbZDCSgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936415AbZDCSgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 14:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757538AbZDCSf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 14:35:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57869 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028AbZDCSf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 14:35:58 -0400
Message-ID: <49D65700.5060202@zytor.com>
Date: Fri, 03 Apr 2009 11:35:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andreas Robinson <andr345@gmail.com>
CC: John Stoffel <john@stoffel.org>, Alain Knaff <alain@knaff.lu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] lib: add fast lzo decompressor
References: <1238593252-3435-1-git-send-email-andr345@gmail.com>	 <1238593252-3435-2-git-send-email-andr345@gmail.com>	 <49D3927A.2050406@zytor.com> <1238613730.10514.35.camel@andreas-desktop>	 <18900.52255.798522.393088@stoffel.org> <1238752196.8118.185.camel@andreas-desktop>
In-Reply-To: <1238752196.8118.185.camel@andreas-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Robinson wrote:
> 
> The kernel and initramfs images are implicitly trusted, but that is not
> unique to this implementation. None of the decompressors check the data
> e.g by comparing checksums, AFAICT.
> 

That's not true.  At least the gzip decompressor definitely checks the 
resulting CRC32.  Being a CRC32, it's a test against corruption, not 
malicious injection, but if you have malicious injection problems this 
can't help you anyway.

However, corruption problems can and do happen during boot, and it's 
really important that we get some kind of useful notification.

	-hpa
