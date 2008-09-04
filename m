Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbYIDHLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbYIDHLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 03:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYIDHLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 03:11:46 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:35071 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbYIDHLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 03:11:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lHmD72/ygQXv0idG3BfxpHwf+TpPgR/4a2bzc+pyrUmCUdE2a4xsT+TJ6MRlzmaXR5
         8FawIajKty9FU07G0EzFoUK49cv5NzK/pm8s9uoXDe6wwrZyq4qPytdGa5V5GQSR6GLm
         mIPiGnKPeHNDRIvnGIqmYVpbuS22hmTQjVtqs=
Message-ID: <ac9c93b10809040011h19b70715ge2ba06372f1b0fe0@mail.gmail.com>
Date: Thu, 4 Sep 2008 09:11:42 +0200
From: "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com>
To: "Nye Liu" <nyet@mrv.com>
Subject: Re: [PATCH] INITRAMFS: Add option to preserve mtime from INITRAMFS cpio images
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Nye Liu" <nyet@nyet.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080903223114.GA9456@mrv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080805195232.GA5183@curtisfong.org>
	 <20080903202938.GA9065@curtisfong.org>
	 <20080903152231.6b82d9bf.akpm@linux-foundation.org>
	 <20080903223114.GA9456@mrv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/4 Nye Liu <nyet@mrv.com>:
> On Wed, Sep 03, 2008 at 03:22:31PM -0700, Andrew Morton wrote:
>> > From: Nye Liu <nyet@nyet.org>
>> >
>> > When unpacking the cpio into the initramfs, mtimes are not preserved by
>> > default. This patch adds an INITRAMFS_PRESERVE_MTIME option that allows mtimes
>> > stored in the cpio image to be used when constructing the initramfs. For
>> > embedded applications that run exclusively out of the initramfs, this is
>> > invaluable.
>>
>> Why is it "invlauable".  Please explain this value in full detail -
>> it's the whole reason for merging the patch!
>
> When building embedded application initramfs images, its nice to know
> when the files were actually created during the build process - that
> makes it easier to see what files were modified when so we can compare
> the files that are being used on the image with the files used during
> the build process. This might help (for example) to determine if the
> target system has all the updated files you expect to see w/o having to
> check MD5s etc.

Hm.

"Invaluable" != "nice to know".

What worries me is that this code is executed at boot time (when
populating the ramfs).
For embedded systems a fast boot time is often important.
I admit that the net effect of this on boot time is marginal (but some
might consider having mtime a marginal benefit), and 100 cents also
make a dollar, so my suggestion would be to either reject this patch
or make it optional (e.g. depending on some debug config flag).

Best regards, Frans.
