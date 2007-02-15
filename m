Return-Path: <linux-kernel-owner+w=401wt.eu-S1030671AbXBOTHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030671AbXBOTHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030675AbXBOTHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:07:05 -0500
Received: from mail.um.es ([155.54.212.109]:46830 "EHLO mail.um.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030671AbXBOTHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:07:03 -0500
X-Greylist: delayed 1734 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Feb 2007 14:07:03 EST
Date: Thu, 15 Feb 2007 19:38:14 +0100 (CET)
From: Juan Piernas Canovas <piernas@ditec.um.es>
X-X-Sender: piernas@ditec.inf.um.es
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: sfaibish <sfaibish@emc.com>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
In-Reply-To: <Pine.LNX.4.61.0702142251460.19368@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0702151910370.19998@ditec.inf.um.es>
References: <op.tnkdlbgsrwwil4@brcsmondepl2c.corp.emc.com>
 <op.tnrbrocsunckof@usensfaibisl2e.eng.emc.com> <Pine.LNX.4.61.0702142251460.19368@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="916140492-708553444-1171564694=:19998"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--916140492-708553444-1171564694=:19998
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

Hi all,

On Wed, 14 Feb 2007, Jan Engelhardt wrote:

>
> On Feb 14 2007 16:10, sfaibish wrote:
>>>
>>> 1. DualFS has only one copy of every meta-data block. This copy is
>>> in the meta-data device,
>
> Where does this differ from typical filesystems like xfs?
> At least ext3 and xfs have an option to store the log/journal
> on another device too.

No, it is not the same. DualFS uses two 'logical' devices, one for data, 
and one for meta-data, but these devices are usually partitions on the 
same disk, they are not two different disks. And DualFS uses the meta-data 
device to both read and write meta-data blocks, whereas the other 
journaling file systems only use the log to write meta-data.

It's true that XFS, Ext3 and other journaling file systems can use a 
separate disk for the log, but, even then, they have to write two copies 
of every meta-data element. However, in this case, DualFS is even better.

If the data and meta-data devices of DualFS can be on different disks, 
DualFS is able to READ and WRITE data and meta-data blocks in PARALLEL. 
The other journaling file systems, however, can only write one of the two 
copies of every meta-data block in parallel to other file systems 
operations, but they can not write the second copy, and read and write 
data and meta-data blocks, in parallel.

>
>>> The DualFS code, tools and performance papers are available at:
>>>
>>> <http://sourceforge.net/projects/dualfs>
>>>
>>> The code requires kernel patches to 2.4.19 (oldies but goodies) and
>>> a separate fsck code.  The latest kernel we used it for is 2.6.11
>>> and we hope with you help to port it to the latest Linux kernel.
>
> Where is the patch for 2.6.11? Sorry, 2.4.19 is just too old (even if
> only considering the 2.4 branch).
> [ And perhaps "goldies" flew better with "oldies" ;-) ]
>

The patch for 2.6.11 is not still stable enough to be released. Be patient 
;-)


 	Juan.
>
> Jan
>

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
--916140492-708553444-1171564694=:19998--
