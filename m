Return-Path: <linux-kernel-owner+w=401wt.eu-S1422694AbXBUSbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422694AbXBUSbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:31:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422760AbXBUSbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:31:47 -0500
Received: from mail.um.es ([155.54.212.109]:55729 "EHLO mail.um.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422694AbXBUSbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:31:46 -0500
Date: Wed, 21 Feb 2007 19:31:40 +0100 (CET)
From: Juan Piernas Canovas <piernas@ditec.um.es>
X-X-Sender: piernas@ditec.inf.um.es
To: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
Cc: Sorin Faibish <sfaibish@emc.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
In-Reply-To: <20070221123753.GA464@lazybastard.org>
Message-ID: <Pine.LNX.4.61.0702211925570.13823@ditec.inf.um.es>
References: <20070216091321.GA28092@lazybastard.org> <45D642A4.5010009@tmr.com>
 <20070217151108.GA301@lazybastard.org> <45D7450F.6090309@tmr.com>
 <20070217183646.GE301@lazybastard.org> <op.tnwuonh3rwwil4@muki-1mj5c5mxes>
 <20070218055936.GF301@lazybastard.org> <Pine.LNX.4.61.0702190625270.8828@ditec.inf.um.es>
 <20070220003059.GJ7813@lazybastard.org> <Pine.LNX.4.61.0702210507500.882@ditec.inf.um.es>
 <20070221123753.GA464@lazybastard.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="916140492-1855166910-1172082700=:13823"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--916140492-1855166910-1172082700=:13823
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

Hi Jörn,

On Wed, 21 Feb 2007, [utf-8] Jörn Engel wrote:

> On Wed, 21 February 2007 05:36:22 +0100, Juan Piernas Canovas wrote:
>>>
>>> I don't see how you can guarantee 50% free segments.  Can you explain
>>> that bit?
>> It is quite simple. If 50% of your segments are busy, and the other 50%
>> are free, and the file system needs a new segment, the cleaner starts
>> freeing some of busy ones. If the cleaner is unable to free one segment at
>> least, your file system gets "full" (and it returns a nice ENOSPC error).
>> This solution wastes the half of your storage device, but it is
>> deadlock-free. Obviously, there are better approaches.
>
> Ah, ok.  It is deadlock free, if the maximal height of your tree is 2.
> It is not 100% deadlock free if the height is 3 or more.
>
> Also, I strongly suspect that your tree is higher than 2.  A medium
> sized directory will have data blocks, indirect blocks and the inode
> proper, which gives you a height of 3.  Your inodes need to get accessed
> somehow and unless they have fixed positions like in ext2, you need a
> further tree structure of some sorts, so you're more likely looking at a
> height of 5.
>
> With a height of 5, you would need to keep 80% of you metadata free.
> That is starting to get wasteful.
>
> So I suspect that my proposed alternate cleaner mechanism or the even
> better "hole plugging" mechanism proposed in the paper a few posts above
> would be a better path to follow.

I do not understand. Do you mean that if I have 10 segments, 5 busy and 5 
free, after cleaning I could need 6 segments? How? Where the extra blocks 
come from?

 	Juan.

-- 
D. Juan Piernas Cánovas
Departamento de Ingeniería y Tecnología de Computadores
Facultad de Informática. Universidad de Murcia
Campus de Espinardo - 30080 Murcia (SPAIN)
Tel.: +34968367657    Fax: +34968364151
email: piernas@ditec.um.es
PGP public key:
http://pgp.rediris.es:11371/pks/lookup?search=piernas%40ditec.um.es&op=index

*** Por favor, envíeme sus documentos en formato texto, HTML, PDF o PostScript :-) ***
--916140492-1855166910-1172082700=:13823--
