Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbYH2Sub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbYH2Sub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 14:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbYH2SuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 14:50:23 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:33860 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbYH2SuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 14:50:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=GGToyZrYn8KoUWC1zSgvOwLmW5aVDbpdN4aNK+thP+Ao2YhBiR5yli4eYoWEMfs68W
         aPk8/cR9+ljp0as7HvPjgcvAqFDdE/gpcqF5Lrz+p0C+Wh2R9pKAlDg0hJGMq3wExZaj
         RIrJTWPtx7tDjOn7Ez9rnKYvgu7OGAEKkAPIU=
Message-ID: <3bc8237c0808291150t2f18ba64vf445bdf4c2c8360c@mail.gmail.com>
Date: Fri, 29 Aug 2008 13:50:21 -0500
From: "Archie Cobbs" <archie@dellroad.org>
To: "Tejun Heo" <tj@kernel.org>
Subject: Re: [fuse-devel] [PATCHSET] CUSE: implement CUSE
Cc: "Mike Hommey" <mh@glandium.org>, fuse-devel@lists.sourceforge.net,
       greg@kroah.com, linux-kernel@vger.kernel.org, miklos@szeredi.hu
In-Reply-To: <48B78EBA.609@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219947544-666-1-git-send-email-tj@kernel.org>
	 <20080829055000.GB18930@glandium.org> <48B78EBA.609@kernel.org>
X-Google-Sender-Auth: 84147c2b4f4ec5f0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 12:52 AM, Tejun Heo <tj@kernel.org> wrote:
> Mike Hommey wrote:
> > On Fri, Aug 29, 2008 at 03:18:59AM +0900, Tejun Heo wrote:
> >> This patchset implements CUSE - Character device in Userspace.  Except
> >> for initialization sequence and creation of character device instead
> >> of a mount, CUSE isn't very different from FUSE.
> >
> > It would be nice to have BUSE, Block device in Userspace, too.
>
> Thought about that but it's really no different from nbd or loop
> depending on your application and block devices don't really implement
> the file operations so it won't have too much in common with FUSE.

I think BUSE would be useful. For one, it allows you to avoid problems with
the extra caching you get with a loopback device. And NBD is too limiting
for some applications.

For my half-ignorant analysis of the caching issues, see:
  http://code.google.com/p/s3backer/wiki/PerformanceConsiderations#Caching

This is also an example of an application where NBD doesn't suffice.

> Also, there's the complication of going out to disk for more memory cases.

Not sure what you mean exactly (my fault), but it seems BUSE would have fewer
places for memory problems (including deadlocks) than loopback over FUSE,
which is the only way to do this kind of stuff now.

-Archie

--
Archie L. Cobbs
