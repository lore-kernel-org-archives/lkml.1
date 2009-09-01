Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbZIAWgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbZIAWgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 18:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbZIAWgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 18:36:52 -0400
Received: from mail-px0-f204.google.com ([209.85.216.204]:63407 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241AbZIAWgv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 18:36:51 -0400
X-Greylist: delayed 1610 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Sep 2009 18:36:51 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=i19JSDoWZLvmSyngnf8aNOI5AR6WcKgypX+A5TyCTe3+OjjyrBhfWHXOSHN+815QqN
         LSYIl3zbFoYM2d2f8/OcODloMk94k7SM3STMwGdUkMLsU6JOzESaz0JtispGPxtMC3RB
         X9PaM6eAWoYoBwYlZZ/9ogZnqfyPSV6CCsUX8=
MIME-Version: 1.0
In-Reply-To: <20090901201943.GB6996@mit.edu>
References: <87y6oyhkz8.fsf@meyering.net> <20090901201943.GB6996@mit.edu>
From: Ulrich Drepper <drepper@gmail.com>
Date: Tue, 1 Sep 2009 15:03:35 -0700
Message-ID: <a36005b50909011503y73efdf56yabc4d981db2989bc@mail.gmail.com>
Subject: Re: make getdents/readdir POSIX compliant wrt mount-point 
	dirent.d_ino
To: Theodore Tso <tytso@mit.edu>, Jim Meyering <jim@meyering.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 1, 2009 at 13:19, Theodore Tso<tytso@mit.edu> wrote:
> Furthermore, there are
> plenty of Unix systems that have received POSIX certifications despite
> having this behavior.

A common misunderstanding of certification.

Like for all certifications, being POSIX certified doesn't mean the
certification is valid for all situations.  it only means that there
is (at least) one configuration which meets the requirements.  In this
case it means the environment simply uses one single filesystem and no
mount points.  This way the problem doesn't even arise.


> Fixing it is also going to be decidedly non-trivial since it depends
> on how the directory was orignally accessed.  [...]

I guess that this is really a difficult way to solve.  I wouldn't want
to pay for something which is hardly ever really used.

But there are programs out there which would like to use the inode
uniqueness.  Therefore the next best thing to do is perhaps to return
a flag in the getdents information (in d_type, perhaps) to indicate
that this is a mount point and/or that there are multiple ways to
access the file in question.  Then programs which can use the inode
information can be watching for this flag and enter the slow path only
if it's set.
