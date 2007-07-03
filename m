Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbXGCFpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbXGCFpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 01:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758670AbXGCFoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 01:44:55 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:59640 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758644AbXGCFox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 01:44:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b0eLDLA/Ey7VAx2zHgAbVlVByVJ6nu5fBWwmmE04AKmfO7/iu8SxBB0rSHm0kynLin11GGha5/RWYYkWvFEIX4kECZcxue4/8lrbWkfgpWF6SttHvBSFsa9BYJlhH0uJky14ZN5NN8RjjdUf8w6KgUeqfI0Rjzweqfnkp3y3FFE=
Message-ID: <4ae3c140707022244j67824c66g5da2d31d8fcfdc0e@mail.gmail.com>
Date: Tue, 3 Jul 2007 01:44:52 -0400
From: "Xin Zhao" <uszhaoxin@gmail.com>
To: "Sunil Joshi" <mail2joshi@gmail.com>
Subject: Re: how do versioning filesystems take snapshot of opened files?
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <778391c50707022236v5157a933qea1994cf4cbce879@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4ae3c140707022228u2b5098c5v766b9dc9a7e09ea1@mail.gmail.com>
	 <778391c50707022236v5157a933qea1994cf4cbce879@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I do know how copy-on-write works. But this seems insufficient to
address the problem I asked.

One possible way is to modify the filesystem so that when a file is
opened for write, we always keep a copy of the file's metadata and a
CoW bitmap. For subsequent writes, we first copy the old data to
somewhere else in memory for backup, mark the CoW bitmap, and then
write to the file. The temporary data is discarded when the file is
closed. By checking the CoW bitmap, the backup application can
determine which data it should copy to the backup media.

This solution can address this problem. But it requires copy-on-write
on every write, no matter whether there is a backup operation. I
suspect that this solution will impact the system performance (at
least write performance) quite a bit and consume more memory.

Any further thought?

Thanks!


On 7/3/07, Sunil Joshi <mail2joshi@gmail.com> wrote:
> It depends how snapshot is being taken. Usually it is Copy On Write. Google
> for Copy on Write and you will find the answer for this.
>
>
>
>
> On 7/3/07, Xin Zhao <uszhaoxin@gmail.com> wrote:
> >
> > Hi,
> >
> >
> > If a file is already opened when snapshot command is issued,  the file
> > itself could be in an inconsistent state already. Before the file is
> > closed, maybe part of the file contains old data, the rest contains
> > new data.
> > How does a versioning filesystem guarantee that the file snapshot is
> > in a consistent state in this case?
> >
> > I googled it but didn't find any answer. Can someone explain it a little
> bit?
> >
> > Thanks
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> >
>
>
