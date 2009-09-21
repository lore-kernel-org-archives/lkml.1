Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbZIUPb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbZIUPb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 11:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756617AbZIUPbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 11:31:24 -0400
Received: from mail-vw0-f203.google.com ([209.85.212.203]:46054 "EHLO
	mail-vw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611AbZIUPbX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 11:31:23 -0400
X-Greylist: delayed 6882 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2009 11:31:23 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=vtvJz6cyR++ZYQ2VO6Dnoe0hLUvJC9c0ToMwVRjMblf3WWBfkqzE+MzNS3/TvhD2G4
         gLP2CHu9h4qkOdSURb0D+CllEHIOdmGpg/tTSLrtYR2c0cNcO902UQlLIoQOIvBs/5aX
         GmUKDfNI5q0DjxCSG/nU3KQO5XmI7naAYMbUs=
MIME-Version: 1.0
In-Reply-To: <20090921144336.GF14381@ZenIV.linux.org.uk>
References: <E1MpiJo-0005fv-2y@pomaz-ex.szeredi.hu> <E1MpiMo-0005h9-DG@pomaz-ex.szeredi.hu> 
	<20090921140220.GD14381@ZenIV.linux.org.uk> <8bd0f97a0909210710h5bb75bcdwb666b51a9155a70a@mail.gmail.com> 
	<20090921143857.GE14381@ZenIV.linux.org.uk> <20090921144336.GF14381@ZenIV.linux.org.uk>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 21 Sep 2009 11:31:07 -0400
Message-ID: <8bd0f97a0909210831g60ceb0e7i96f52690ac6490ed@mail.gmail.com>
Subject: Re: [PATCH 2/2] vfs: fix d_path() for unreachable paths
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu, agruen@suse.de, hch@lst.de,
       hugh.dickins@tiscali.co.uk, matthew@wil.cx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 10:43, Al Viro wrote:
> On Mon, Sep 21, 2009 at 03:38:57PM +0100, Al Viro wrote:
>> On Mon, Sep 21, 2009 at 10:10:17AM -0400, Mike Frysinger wrote:
>> > it works without having to copy & paste the same exact structures over
>> > and over.  a suggestion as how to do it cleanly without bloating the
>> > code is certainly welcome.  it doesnt really matter that it's on the
>> > stack as the usage is small and d_path() is given the size of the
>> > buffer, so it isnt going to overflow.
>
> PS: as to why it is broken...  Consider e.g.
>        mount --bind /proc/cplbinfo/cpu0 /mnt
>        cat /mnt/icplb
> Or, better yet,
>        mount -t proc none /mnt/cpu
>        cat /mnt/cpu/cplbinfo/cpu0/icplb

i'm not disagreeing that it doesnt work under all random VFS
scenarios.  just that the realistic ones all work.
-mike
