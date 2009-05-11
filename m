Return-Path: <linux-kernel-owner+w=401wt.eu-S1758993AbZEKSEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758993AbZEKSEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbZEKSEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:04:37 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:64634 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756793AbZEKSEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:04:36 -0400
MIME-Version: 1.0
In-Reply-To: <20090511185513.45ea4754@lxorguk.ukuu.org.uk>
References: <20090509143742.GA27663@kroah.com> <20090511115504.568c9a92@lxorguk.ukuu.org.uk> 
	<ac3eb2510905110434nb123423m134e848c17c3c736@mail.gmail.com> 
	<20090511141057.24a5f8ed@lxorguk.ukuu.org.uk> <ac3eb2510905110714m5877da13q19b42d1c8565777c@mail.gmail.com> 
	<20090511165317.3da5326f@lxorguk.ukuu.org.uk> <ac3eb2510905110928g12545518y143f7f73b3ae494a@mail.gmail.com> 
	<20090511094151.6014cafb@infradead.org> <ac3eb2510905111032u13051b74g81573a18e3545a81@mail.gmail.com> 
	<20090511185513.45ea4754@lxorguk.ukuu.org.uk>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 11 May 2009 20:04:16 +0200
Message-ID: <ac3eb2510905111104g5ce4e8e6xf8b4de41454c3d2f@mail.gmail.com>
Subject: Re: [patch 00/13] devtmpfs patches
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 19:55, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> The same applies when you leave initiramfs, the in-initramfs udevd
>> copy is killed, and the one from the real root is started. You may
>> miss events in-between, and need to run a full coldplug again, not
>> only to apply the policy, but also to make sure that all nodes are
>> there. The policy can run in the background for most things just fine,
>> the missing node may cause trouble.
>
> What a strange behaviour. Why not run a single udev instance inside the
> tmpfs you are turning into dev and will then attach to the real rootfs
> when it appears ? You only need to build /dev once.

Because the udev in initramfs has no clue about uid/gid, has not the
tools it needs for a full setup, has not the same rules as the one in
the real root. Ignoring the fact, that people may run different
versions in initramfs and the real root. There is no sane option so
far, not to replace the udevd process from initramfs.

>> Yeah, and I mentioned many other ways this is useful, to do stuff in
>> parallel, to be able to rescue, and to have custom systems which do
>
> But there are lots where it is not - and those you've mentioned where it
> might be seem rather stretched at best.

Right, but the information you need for all other use cases is already
there today in /sys. This is about something new, so there is not a
competition about features, just an option to solve a problem in a
different way, which we prefer over the current one.

Thanks,
Kay
