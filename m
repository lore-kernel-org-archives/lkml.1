Return-Path: <linux-kernel-owner+w=401wt.eu-S1765017AbXG3PYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765017AbXG3PYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 11:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755960AbXG3PYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 11:24:09 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:59507 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927AbXG3PYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 11:24:06 -0400
Message-ID: <46AE01C2.3000008@oracle.com>
Date: Mon, 30 Jul 2007 11:20:34 -0400
From: Chuck Lever <chuck.lever@oracle.com>
Reply-To: chuck.lever@oracle.com
Organization: Corporate Architecture, Linux Projects Group
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kzak@redhat.com, ericvh@gmail.com,
       lucho@ionkov.net, zippel@linux-m68k.org, hpa@zytor.com,
       raven@themaw.net, rathamahata@php4.ru, dhowells@redhat.com,
       sfrench@samba.org, mhalcrow@us.ibm.com, phillip@hellewell.homeip.net,
       hirofumi@mail.parknet.co.jp, mikulas@artax.karlin.mff.cuni.cz,
       wli@holomorphy.com, shaggy@austin.ibm.com, vandrove@vc.cvut.cz,
       trond.myklebust@fys.uio.no, aia21@cantab.net, mark.fasheh@oracle.com,
       kurt.hackel@oracle.com, reiserfs-devel@vger.kernel.org,
       bfennema@falcon.csc.calpoly.edu, dushistov@mail.ru,
       xfs-masters@oss.sgi.com, arnd@arndb.de, holzheu@de.ibm.com
Subject: Re: request for patches: showing mount options
References: <E1IEQ7q-0000qE-00@dorka.pomaz.szeredi.hu> <46AA4AC5.2050200@oracle.com> <E1IEW21-0001kL-00@dorka.pomaz.szeredi.hu> <46AA51CA.7030105@oracle.com> <E1IEezF-0002g6-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1IEezF-0002g6-00@dorka.pomaz.szeredi.hu>
Content-Type: multipart/mixed;
 boundary="------------030900090601050100040108"
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030900090601050100040108
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



Miklos Szeredi wrote:
>>>> Some mount options are never passed to the kernel, and thus can't appear 
>>>> in /proc/mounts.  Examples include user, users, and _netdev for NFS.
>>> These options control *who* may mount and *when* to mount.  They are
>>> not a property of the mount itself and are not added to /etc/mtab.
>>>
>>> There's a "user=ID" option that is added to /etc/mtab in case of user
>>> mounts.  This identifies the owner of the mount, so that it can be
>>> unmounted by that user.  There are patches in -mm that enable the
>>> kernel to store this info.
>>>
>>> Do you have other examples in mind?

There are a few more cases for NFS mount.

After a successful mount, the NFS mount command tucks some options into 
/etc/mtab that reflect which mountd was used for the mount, and what 
protocol version and port was used for the mount request.  Those options 
are not passed to the kernel, and do not appear in /proc/mounts today. 
See nfs(5)'s discussion of the mountport, mounthost, mountprog, and 
mountvers options.

However, the trend for NFS is to push mount option parsing into the 
kernel.  Thus all options will be passed to the kernel, and at that 
point it should be able to reflect the mount* options in /proc/mounts. 
But it doesn't do that quite yet.

I'm wondering if there are other such cases in other file systems.

--------------030900090601050100040108
Content-Type: text/x-vcard; charset=utf-8;
 name="chuck.lever.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="chuck.lever.vcf"

begin:vcard
fn:Chuck Lever
n:Lever;Chuck
org:Oracle Corporation;Corporate Architecture: Linux Projects Group
adr:;;1015 Granger Avenue;Ann Arbor;MI;48104;USA
title:Principal Member of Staff
tel;work:+1 248 614 5091
x-mozilla-html:FALSE
url:http://oss.oracle.com/~cel
version:2.1
end:vcard


--------------030900090601050100040108--
