Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbYAMTuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbYAMTuA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 14:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbYAMTtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 14:49:52 -0500
Received: from mail.parknet.ad.jp ([210.171.162.6]:56162 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbYAMTtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 14:49:51 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Grant Likely" <grant.likely@secretlab.ca>
Cc: "Steven Cavanagh" <steven.cavanagh@secretlab.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fat: Editions to support fat_fallocate()
References: <20071222210958.9351.35913.stgit@jpe-laptop>
	<fa686aa40712221418m601d3ffrd5b9158104712078@mail.gmail.com>
	<87tzm91u98.fsf@duaron.myhome.or.jp>
	<fa686aa40712231223j18b83ff6ne5ade95a88ebbc79@mail.gmail.com>
Date: Mon, 14 Jan 2008 04:49:46 +0900
In-Reply-To: <fa686aa40712231223j18b83ff6ne5ade95a88ebbc79@mail.gmail.com>
	(Grant Likely's message of "Sun, 23 Dec 2007 13:23:22 -0700")
Message-ID: <873at1wlnp.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Grant Likely" <grant.likely@secretlab.ca> writes:

> On 12/23/07, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:
>> "Grant Likely" <grant.likely@secretlab.ca> writes:
>> >
>> > However, digging further, when FALLOC_FL_KEEP_SIZE is set, I don't
>> > think fat_cont_expand() has the behaviour that we want to implement.
>> > When that flag is set, I think we simply want to add clusters
>> > associated with the file to the FAT.  We don't want to clear them or
>> > map them into the page cache yet (that should be done when the
>> > filesize is increased for real).
>> >
>> > I believe a call to fat_allocate_clusters() is all that is needed in
>> > this case.  Hirofumi, please correct me if I'm wrong.
>>
>> Right. And we need to care the limitation on FAT specification (compatibility).
>
> I not sure I fully understand what you mean.  Can you please
> elaborate?  Are you referring to whether on not it will break other
> FAT implementations if a file has more clusters allocated than it
> needs?  If so, how do we decide whether or not it is acceptable?

[Sorry for long delay. I was on vacation.]

Probably we need to check how Widnows behave in some situations.

E.g. if we store the longer cluster-chain than i_size (in the case of
FALLOC_FL_KEEP_SIZE), the driver will be seen like corrupted files.
Because we doesn't know the file is whether file was "fallocate" or not
after reboot.  At least, I think current linux implementation will
detect it as corrupted file (filesystem).

So we have to handle somehow those situations. Also I think we'll need
to more investigate problem like this.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
