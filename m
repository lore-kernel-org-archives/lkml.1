Return-Path: <linux-kernel-owner+w=401wt.eu-S1757917AbXGCQMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917AbXGCQMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbXGCQMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:12:42 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:43123 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbXGCQMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:12:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fT/oCtVuDwp3IbxLBZZ/b9FYA663hc3HYqENjiCabpj/0SEfjgQ/AFwLLcLwAW6gbs+fNTDWjCGWp4PA82f6PyDE2eKC5NBw5HFZDgnfaYzod5zKWVJFYx4dXWXGlhuDjKHVhK5nBuPWqy2MUMwNv+atbou4fTMEm3rY8EdkWF8=
Message-ID: <4ae3c140707030912m59fc956k9e4da94e173fa171@mail.gmail.com>
Date: Tue, 3 Jul 2007 12:12:40 -0400
From: "Xin Zhao" <uszhaoxin@gmail.com>
To: "Chris Mason" <chris.mason@oracle.com>
Subject: Re: how do versioning filesystems take snapshot of opened files?
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070703090946.49e6062f@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4ae3c140707022228u2b5098c5v766b9dc9a7e09ea1@mail.gmail.com>
	 <20070703090946.49e6062f@think.oraclecorp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your reply.

Sounds like one has to stop or pause the applications to get
consistent snapshot?  But you look around, you may find that many
systems claim that they can take snapshot without shutdown the
application. Actually, I think it is impractical to require that app
to be shutdown before taking snapshot in a commercial environment.

Pausing apps is possible from the filesystem perspective. A simple
solution is that the filesystem stop writing any data to disk from the
point that the snapshotting command is received. But as we discussed
earlier, this is not sufficient to prevent a file from containing part
of old data and part of new data.

That's why I am so confused how can these systems provide consistent
snapshotting capability without sacrificing system performance much.



On 7/3/07, Chris Mason <chris.mason@oracle.com> wrote:
> On Tue, 3 Jul 2007 01:28:57 -0400
> "Xin Zhao" <uszhaoxin@gmail.com> wrote:
>
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
> > I googled it but didn't find any answer. Can someone explain it a
> > little bit?
>
> It's the same answer as in most filesystem related questions...it
> depends ;)  Consistent state means many different things.  It may mean
> that the metadata accurately reflects the space on disk allocated to
> the file and that all data for the file is properly on disk (ie from an
> fsync).
>
> But, even this is less than useful because very few files on the
> filesystem stand alone.  Applications spread their state across a
> number of files and so consistent means something different to
> every application.
>
> Getting a snapshot that is useful with respect to application data
> requires help from the application.  The app needs to be shutdown or
> paused prior to the snapshot and then started up again after the
> snapshot is taken.
>
> -chris
>
>
>
