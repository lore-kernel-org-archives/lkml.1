Return-Path: <linux-kernel-owner+w=401wt.eu-S965327AbXBUEg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965327AbXBUEg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 23:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965356AbXBUEg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 23:36:26 -0500
Received: from mail.um.es ([155.54.212.109]:45995 "EHLO mail.um.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965327AbXBUEg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 23:36:26 -0500
Date: Wed, 21 Feb 2007 05:36:22 +0100 (CET)
From: Juan Piernas Canovas <piernas@ditec.um.es>
X-X-Sender: piernas@ditec.inf.um.es
To: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
Cc: Sorin Faibish <sfaibish@emc.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
In-Reply-To: <20070220003059.GJ7813@lazybastard.org>
Message-ID: <Pine.LNX.4.61.0702210507500.882@ditec.inf.um.es>
References: <20070215200922.GB24643@lazybastard.org>
 <Pine.LNX.4.61.0702152353060.19998@ditec.inf.um.es> <20070216091321.GA28092@lazybastard.org>
 <45D642A4.5010009@tmr.com> <20070217151108.GA301@lazybastard.org>
 <45D7450F.6090309@tmr.com> <20070217183646.GE301@lazybastard.org>
 <op.tnwuonh3rwwil4@muki-1mj5c5mxes> <20070218055936.GF301@lazybastard.org>
 <Pine.LNX.4.61.0702190625270.8828@ditec.inf.um.es> <20070220003059.GJ7813@lazybastard.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="916140492-916379374-1172032582=:882"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--916140492-916379374-1172032582=:882
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

Hi Jörn,

On Tue, 20 Feb 2007, [utf-8] Jörn Engel wrote:

> On Tue, 20 February 2007 00:57:50 +0100, Juan Piernas Canovas wrote:
>>
>> Actually, the GC may become a problem when the number of free segments is
>> 50% or less. If your LFS always guarantees, at least, 50% of free
>> "segments" (note that I am talking about segments, not free space), the
>> deadlock problem disappears, right? This is a quite naive solution, but it
>> works.
>
> I don't see how you can guarantee 50% free segments.  Can you explain
> that bit?
It is quite simple. If 50% of your segments are busy, and the other 50% 
are free, and the file system needs a new segment, the cleaner starts 
freeing some of busy ones. If the cleaner is unable to free one segment at 
least, your file system gets "full" (and it returns a nice ENOSPC error). 
This solution wastes the half of your storage device, but it is 
deadlock-free. Obviously, there are better approaches.

>
>> In a traditional LFS, with data and meta-data blocks, 50% of free segments
>> represents a huge amount of wasted disk space. But, in DualFS, 50% of free
>> segments in the meta-data device is not too much. In a typical Ext2,
>> or Ext3 file system, there are 20 data blocks for every meta-data block
>> (that is, meta-data blocks are 5% of the disk blocks used by files).
>> Since files are implemented in DualFS in the same way, we can suppose the
>> same ratio for DualFS (1).
>
> This will work fairly well for most people.  It is possible to construct
> metadata-heavy workloads, however.  Many large directories containing
> symlinks or special files (char/block devices, sockets, fifos,
> whiteouts) come to mind.  Most likely noone of your user will ever want
> that, but a malicious attacker might.
>
Quotas, bigger meta-data device, cleverer cleaner,... there are 
solutions :)

>> The point of all the above is that you must improve the common case, and
>> manage the worst case correctly. And that is the idea behind DualFS :)
>
> A fine principle to work with.  Surprisingly, what is the worst case for
> you is the common case for LogFS, so maybe I'm more interested in it
> than most people.  Or maybe I'm just more paranoid.
>

No, you are right. It is the common case for LogFS because it has data and 
meta-data blocks in the same address space, but that is not the case of 
DualFS. Anyway, I'm very interested in your work because any solution to 
the problem of the GC will be also applicable to DualFS. So, keep up with 
it. ;-)

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
--916140492-916379374-1172032582=:882--
