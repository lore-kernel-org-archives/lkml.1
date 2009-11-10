Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbZKJMZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbZKJMZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 07:25:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbZKJMZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 07:25:59 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:58829 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbZKJMZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 07:25:58 -0500
MIME-Version: 1.0
In-Reply-To: <a4875c0e0911100424h947058bg5c7efc6e2d7d817c@mail.gmail.com>
References: <a4875c0e0911091128g3920726bk2e20be67920dc483@mail.gmail.com>
	 <a4875c0e0911100417j1a9fba09tce5da4a5511111c0@mail.gmail.com>
	 <a4875c0e0911100424h947058bg5c7efc6e2d7d817c@mail.gmail.com>
Date: Tue, 10 Nov 2009 13:26:02 +0100
Message-ID: <a4875c0e0911100426t2e95cf21g8bbad12438804ef6@mail.gmail.com>
Subject: Fwd: eifs/fmfs (everything is filesystem/file mapping filesystem)
From: mobi phil <mobi@mobiphil.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was writing the following email to the linux-fsdevel, but as it
might involve other parts of the kernel, I would share it on this ML
as well. Your feedback is more than welcome.


---------- Forwarded message ----------
From: mobi phil <mobi@mobiphil.com>
Date: Mon, Nov 9, 2009 at 8:28 PM
Subject: eifs/fmfs (everything is filesystem/file mapping filesystem)
To: linux-fsdevel@vger.kernel.org


Hello mailing list members,

I am not sure about the best name, but I am sure it is sthg. very
usefull. So I will call it mobifs, hope you do not mind :) I am also
not sure if there is sthg. like that out there, but based on my 15
years of linux experience I never met sthg. like what I would like to
talk about.

What I would like to have on my linux boxes is to access data the following way:

#>cat /dev/sda1@/partition1/etc/inittab@/defaultranlevel #usecase 0

#>cat /data/xmlfiles/apsettings.xml@xml/main/entry1/subentry/value #usecase 1
or
#>cat /data/xmlfiles/apsettings.xml@/main/entry1/subentry/value
#note @ instead of  @xml #usecase 2
or
#>cat /data/images/linux.img/@/partition1/etc/dhcpd/dhcpd.conf@group/next-server
 #note twice the @  #usecase 3

I think you got the point. It is actually not a real filesystem, but
an extension to the virtual filesystem.

How would it work? If the virtual filesystem subsystem of the kernel
finds an @ it would redirect the call to the mobifs main module. The
mobifs will check if there is any string after @ till the next /. If
yes, it will look if there is any driver installed with that name. In
usecase 1, it will look if there is a driver to read xml files. If
yes, it will call the driver and pass the rest of the string to it.
The xml driver will interpret the path request and output the
necessary entry.

If there is nothing specified like in usecase0 (note annoying tmp.
mount not needed!!!)mobifs will try to guess, and if he finds a
matching filetype (like the file command or mount does) it would pass
the path to  the driver if there is any driver registered for that.

Drivers can be partition readers (do not know oficial technical name
:)), existing filesystem drivers etc. It should be possible to have
kerenel drivers and userspace drivers. It seems rather logical that
for reading filesystems one would use kernelspace drivers, and
for trivial file mapping operations userspace program would fit better.

Usecas0 has twice @. This should mean double "redirection" or piping.
Mobifs should help to feed the output of one driver with the input of
next one, etc. In case of usecase 0, the one driver would read the
filesystem on sda1, and feed the read of the driver that is able to
read inittab files.

If sthg. like that would become to being, I would see its evolution as
2 main steps: first create read only support, and then add write
support. The same would happen with the drivers...

I was thinking about this the last few days, started to hack around
the kernel, but before going to the wrong direction, I wanted to ask
more experienced people about what and what not to do!

for some more imagined usecases, see the PS.


rgrds,
mobi phil

being mobile, but including technology
http://mobiphil.com


P.S.

#>cat /databases/mysqldatabase/db.sql@mysql/tables/table1/2345/rowname
#>cat /databases/mysqldatabase/db.sql@mysql/tables/table1/rowname/1232
#>cat /databases/mysqldatabase/db.sql@mysql/tables/table1/rowname

#>cat /xxx/xx/xx/xx/elfimage@elf/symbols

#>cat /sourcecode/cpp/thismodule/thatfile.h@cpp/methodist
#>cat /sourcecode/cpp/thismodule/thatfile.h@cpp/includelist
#>cat /sourcecode/cpp/thismodule/thatfile.cpp@cpp/methods/thatmethod

#>cat /sourcecode/cpp/thismodule/thatfile.h@cpp/methodist

#>tail -f /var/log/messages@grep/error #maybe this is less usefull



--
rgrds,
mobi phil

being mobile, but including technology
http://mobiphil.com



--
rgrds,
mobi phil

being mobile, but including technology
http://mobiphil.com



-- 
rgrds,
mobi phil

being mobile, but including technology
http://mobiphil.com
