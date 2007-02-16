Return-Path: <linux-kernel-owner+w=401wt.eu-S1423234AbXBPE5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423234AbXBPE5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 23:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423233AbXBPE5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 23:57:37 -0500
Received: from mail.um.es ([155.54.212.109]:45459 "EHLO mail.um.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423231AbXBPE5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 23:57:35 -0500
Date: Fri, 16 Feb 2007 05:57:41 +0100 (CET)
From: Juan Piernas Canovas <piernas@ditec.um.es>
X-X-Sender: piernas@ditec.inf.um.es
To: Andi Kleen <andi@firstfloor.org>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, sfaibish <sfaibish@emc.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
In-Reply-To: <20070215235716.GA14199@one.firstfloor.org>
Message-ID: <Pine.LNX.4.61.0702160547500.21931@ditec.inf.um.es>
References: <op.tnkdlbgsrwwil4@brcsmondepl2c.corp.emc.com>
 <op.tnrbrocsunckof@usensfaibisl2e.eng.emc.com> <Pine.LNX.4.61.0702142251460.19368@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0702151910370.19998@ditec.inf.um.es> <p73sld7f96t.fsf@bingen.suse.de>
 <Pine.LNX.4.61.0702152152460.19998@ditec.inf.um.es> <20070215235716.GA14199@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="916140492-306198123-1171601861=:21931"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--916140492-306198123-1171601861=:21931
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

Hi,

On Fri, 16 Feb 2007, Andi Kleen wrote:

>>> If you stripe two disks with a standard fs versus use one of them
>>> as metadata volume and the other as data volume with dualfs i would
>>> expect the striped variant usually be faster because it will give
>>> parallelism not only to data versus metadata, but also to all data
>>> versus other data.
>>>
>> If you have a RAID system, both the data and meta-data devices of DualFS
>> can be stripped, and you get the same result. No problem for DualFS :)
>
> Sure, but then you need four disks. And if your workloads happens
> to be much more data intensive than metadata intensive the
> stripped spindles assigned to metadata only will be more idle
> than the ones doing data.
>
> Stripping everything from the same pool has the potential
> to adapt itself to any workload mix better.
>
Why do you need four disks? Data and meda-data devices of DualFS can be on 
different disks, can be two partitions of the same disk, or can be two 
areas of the same partition. The important thing is that data and 
meta-data blocks are separated and that they are managed in different 
ways. Please, take a look at the presentation (see below).

> I can see that you win for some specific workloads, but it is
> hard to see how you can win over a wide range of workloads
> because of that.
>
No, we win for a wide range of common workloads. See the results in the 
PDF (see below).

>>
>>> Also I would expect your design to be slow for metadata read intensive
>>> workloads. E.g. have you tried to boot a root partition with dual fs?
>>> That's a very important IO benchmark for desktop Linux systems.
>>>
>> I do not think so. The performance of DualFS is superb in meta-data read
>> intensive workloads . And it is also better than the performance of other
>> file system when reading a directory tree with several copies of the Linux
>> kernel source code (I showed those results on Tuesday at the LSF07
>> workshop)
>
> PDFs available?
>
Sure:

 	http://www.ditec.um.es/~piernas/dualfs/presentation-lsf07-final.pdf

> Is that with running a LFS style cleaner inbetween or without?
>
'With' a cleaner.

> I would be interested in a "install distro with installer ; boot afterwards
> from it" type benchmark. Do you have something like this?
>
> -Andi

I think that the results sent by Sorin answer your question :-)

Regards,

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
--916140492-306198123-1171601861=:21931--
