Return-Path: <linux-kernel-owner+w=401wt.eu-S1753315AbYIBRr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbYIBRr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 13:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYIBRrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 13:47:49 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:23174 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbYIBRrs (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 13:47:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=q7y+GAPTX79Eetp4C+UBStWeXemvvmmM01M4OMPDxgtro3eoK4HnFf5ilgS3t0jzb0
         rXVLXOsMi+o7E18wiVJU557QO5DWFN0LgAA+VK5CzppCtcxoG9DNZCTHtbwdCX74Ks2+
         RJv+zwC5FPnsbImj3PfudZgmr9BZDMEWB/WNA=
Message-ID: <6934efce0809021047h40127b72u5d35f457e0546635@mail.gmail.com>
Date: Tue, 2 Sep 2008 10:47:45 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Cc: "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <20080902171500.GC19618@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD00C4.6060302@gmail.com>
	 <Pine.LNX.4.64.0808221650500.17105@vixen.sonytel.be>
	 <6934efce0808220951i5a2cd6f9t70f9c522eae6f1d6@mail.gmail.com>
	 <Pine.LNX.4.64.0808281737150.28552@vixen.sonytel.be>
	 <Pine.LNX.4.64.0809021725480.3986@vixen.sonytel.be>
	 <6934efce0809020944s36dd7f82wec77c4189ef1b114@mail.gmail.com>
	 <20080902171500.GC19618@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> How is one expected to read those last 4 bytes of a loopbacked file?
>> Are they unreadable?  We can add the padding.   I am just wondering if
>> this is a bug or a known limitation in the loopback handling or if
>> there is a different safer way of reading block devs with truncated
>> last blocks.
>
> Can't you just include the final magic into the last block, thereby
> making the size a clean multiple of 4k?  It looks as if you have some
> padding before the magic anyway.  So you just have to make sure the
> padding is at least 4 bytes and write the magic to the end of it.  Apart
> from solving this bug, it should also save you some space. ;)

I'm going to have to look into this n*4K thing.  The image doesn't
need to be aligned.  There shouldn't be any last block to put the
magic in.  But I haven't messed with the mkfs.axfs code for a while.
