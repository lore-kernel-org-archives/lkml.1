Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbYIBQob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbYIBQob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 12:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbYIBQoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 12:44:22 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:5548 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbYIBQoV (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 12:44:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=m6zc9P8JLey7W0s24SmYnvWHeyNIS6MhKXDG1dgZaa5mw4a9qD7hnLKGT8RaAtp4bp
         tDNrF4LEL+Pmub/9oH5ODixLkCGHmOmPFucYXYaO+Eu7xwAqxM8zLG5Ay500NeqbZ2Bg
         dqv7G7RCg7dM6lylGM9pT3hqcOmrZaE0/LdiE=
Message-ID: <6934efce0809020944s36dd7f82wec77c4189ef1b114@mail.gmail.com>
Date: Tue, 2 Sep 2008 09:44:19 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <Pine.LNX.4.64.0809021725480.3986@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD00C4.6060302@gmail.com>
	 <Pine.LNX.4.64.0808221650500.17105@vixen.sonytel.be>
	 <6934efce0808220951i5a2cd6f9t70f9c522eae6f1d6@mail.gmail.com>
	 <Pine.LNX.4.64.0808281737150.28552@vixen.sonytel.be>
	 <Pine.LNX.4.64.0809021725480.3986@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I found what's wrong.
>
> The size of an AxFS image created by mkfs.axfs is always n*4096+4 bytes large.
> So when it wants to check the magic value in the last 4 bytes, the block layer
> tries to read a whole 512-byte sector, which fails for loop-mounted images.
>
> If you test on real FLASH, additional bytes after the end of the AxFS image can
> be read, hence it works.
>
> By padding the image with 508 zero bytes, I can mount it, on both PS3 (ppc64)
> and UML (ai32). I can even read images created on PS3.

Right.  We haven't tested loopback since we added the magic end value.

How is one expected to read those last 4 bytes of a loopbacked file?
Are they unreadable?  We can add the padding.   I am just wondering if
this is a bug or a known limitation in the loopback handling or if
there is a different safer way of reading block devs with truncated
last blocks.

> However, there still are weird things going on, like `find' not seeing all
> files and directories, or just aborting, and `ls -lR' showing actual file
> contents in its output.

Do you see this behavior for all builds for just the PS3?
