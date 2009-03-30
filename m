Return-Path: <linux-kernel-owner+w=401wt.eu-S1757009AbZC3Glq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009AbZC3Glq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 02:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbZC3Glh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 02:41:37 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:20241 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbZC3Glg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 02:41:36 -0400
X-RZG-AUTH: :LWIQcGC8af5qXkYNYt77sURZEFmV4M3TAgvB+Qeh4tE+44JfzNXfZkKf55cV
X-RZG-CLASS-ID: mo05
Message-ID: <49D06998.2050301@ursus.ath.cx>
Date: Mon, 30 Mar 2009 08:41:28 +0200
From: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <49CD4DDF.3000001@garzik.org> <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <49D03621.5080501@rtr.ca>
In-Reply-To: <49D03621.5080501@rtr.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 30.03.2009 05:01 Mark Lord wrote:
> Dave Chinner wrote:
>> On Sat, Mar 28, 2009 at 11:17:08AM -0400, Mark Lord wrote:
>>> The better solution seems to be the rather obvious one:
>>>
>>>   the filesystem should commit data to disk before altering metadata.
>>
>> Generalities are bad. For example:
>>
>> write();
>> unlink();
>> <do more stuff>
>> close();
>>
>> This is a clear case where you want metadata changed before data is
>> committed to disk. In many cases, you don't even want the data to
>> hit the disk here.
> ..
>
> Err, no actually.  I want a consistent disk state,
> either all old or all new data after a crash.
>
>

Dave is right that if you write to a file and unlink the same file, so
that the data are orphaned. In that case you don't want the orphaned
data to be written on disk. But Mark is right, too. Because in that case
you probably also don't want any metadata to be written to the disk,
unless the open() was already commited. You might have to update
timestamps for the directory.
So rephrasing it:
The filesystem should not alter the metadata before writing the _linked_
data.


