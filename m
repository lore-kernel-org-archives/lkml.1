Return-Path: <linux-kernel-owner+w=401wt.eu-S1161311AbXBOVJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161311AbXBOVJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 16:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161310AbXBOVJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 16:09:24 -0500
Received: from mail.um.es ([155.54.212.109]:49212 "EHLO mail.um.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161306AbXBOVJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 16:09:23 -0500
Date: Thu, 15 Feb 2007 22:09:19 +0100 (CET)
From: Juan Piernas Canovas <piernas@ditec.um.es>
X-X-Sender: piernas@ditec.inf.um.es
To: Andi Kleen <andi@firstfloor.org>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, sfaibish <sfaibish@emc.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
In-Reply-To: <p73sld7f96t.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.61.0702152152460.19998@ditec.inf.um.es>
References: <op.tnkdlbgsrwwil4@brcsmondepl2c.corp.emc.com>
 <op.tnrbrocsunckof@usensfaibisl2e.eng.emc.com> <Pine.LNX.4.61.0702142251460.19368@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0702151910370.19998@ditec.inf.um.es> <p73sld7f96t.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="916140492-1829416445-1171573759=:19998"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--916140492-1829416445-1171573759=:19998
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

Hi Andi,

On Thu, 15 Feb 2007, Andi Kleen wrote:

> Juan Piernas Canovas <piernas@ditec.um.es> writes:
>
> [playing devil's advocate here]
>
>> If the data and meta-data devices of DualFS can be on different disks,
>> DualFS is able to READ and WRITE data and meta-data blocks in
>> PARALLEL.
>
> XFS can do this too using its real time volumes (which don't contain
> any metadata).  It can also have a separate log.

But you still need several 'real' devices to separate data and meta-data 
blocks. DualFS does the same with just one real device. Probably 'data 
device' and 'meta-data device' names are a bit confusing. Think about 
them as partitions, not as real devices.

>
> Also many storage subsystems have some internal parallelism
> in writing (e.g. a RAID can write on different disks in parallel for
> a single partition) so i'm not sure your distinction is that useful.
>
But we are talking about a different case. What I have said is that if you 
use two devices, one for the 'regular' file system and another one for the 
log, DualFS is better in that case because it can use the log for reads. 
Other journaling file systems can not do that.

> If you stripe two disks with a standard fs versus use one of them
> as metadata volume and the other as data volume with dualfs i would
> expect the striped variant usually be faster because it will give
> parallelism not only to data versus metadata, but also to all data
> versus other data.
>
If you have a RAID system, both the data and meta-data devices of DualFS 
can be stripped, and you get the same result. No problem for DualFS :)

> Also I would expect your design to be slow for metadata read intensive
> workloads. E.g. have you tried to boot a root partition with dual fs?
> That's a very important IO benchmark for desktop Linux systems.
>
I do not think so. The performance of DualFS is superb in meta-data read 
intensive workloads. And it is also better than the performance of other 
file system when reading a directory tree with several copies of the Linux 
kernel source code (I showed those results on Tuesday at the LSF07 
workshop).

> -Andi
>

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
--916140492-1829416445-1171573759=:19998--
