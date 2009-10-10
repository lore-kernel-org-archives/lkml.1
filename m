Return-Path: <linux-kernel-owner+w=401wt.eu-S1756855AbZJJJwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbZJJJwT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 05:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756737AbZJJJwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 05:52:18 -0400
Received: from mga06.intel.com ([134.134.136.21]:32928 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756345AbZJJJwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 05:52:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,536,1249282800"; 
   d="gz'50?scan'50,208,50";a="558316013"
Subject: Re: fio rand read/write regression with 2.6.32-rc3
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20091010080117.GN9228@kernel.dk>
References: <1255153724.25078.68.camel@ymzhang>
	 <20091010080117.GN9228@kernel.dk>
Content-Type: multipart/mixed; boundary="=-EY2VlgPcUzHxOfsdjloT"
Date: Sat, 10 Oct 2009 17:52:13 +0800
Message-Id: <1255168333.25078.82.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EY2VlgPcUzHxOfsdjloT
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, 2009-10-10 at 10:01 +0200, Jens Axboe wrote:
> On Sat, Oct 10 2009, Zhang, Yanmin wrote:
> > Comparing with 2.6.23-rc1's result, fio rand read write has regression
> > on my 2*4 core stoakley machine (8GB memory) with a JBOD of 12 disks.
> > 
> > Every disk has 8 1-GB files. Start 8 sub-processes per disk and every
> > process random chooses a file on the disk to do 36 times of file read or
> > write on the file and then choose another file.
> > 
> > 
> > fio_mmap_rand_read_4k regresion is about 35%.
> 
> Heh, I seem to recollect I told Linus that this would cost is 30-40%
> performance. So not totally crazy.
> 
> So yes, this isn't hugely unexpected. If you send me your fio job files,
> I'll try and see what I can do about it.
See the attachment.

> 
> > Bisect down to patch:
> > 1d2235152dc745c6d94bedb550fea84cffdbf768 is first bad commit
> > commit 1d2235152dc745c6d94bedb550fea84cffdbf768
> > Author: Jens Axboe <jens.axboe@oracle.com>
> > Date:   Fri Oct 2 19:27:04 2009 +0200
> > 
> >     cfq-iosched: add a knob for desktop interactiveness
> > 
> > 
> > After I revert the patch against 2.6.23-rc3, fio_mmap_rand_read_4k regression
> > disappears.
> > 
> > fio_mmap_randrw_4k has less than 20% regression and reverting the patch
> > could restore performance.
> > 
> > On another stoakley machine with another JBOD, we see the similiar regression.
> > 
> > ffsb rand read/write has a bigger regression and reverting the patch
> > could restore performance.
> > 
> > Yanmin
> > 
> > 
> 

--=-EY2VlgPcUzHxOfsdjloT
Content-Disposition: attachment; filename=job_file_st01_fio_mmap_randread_4k.gz
Content-Type: application/x-gzip; name=job_file_st01_fio_mmap_randread_4k.gz
Content-Transfer-Encoding: base64

H4sICJ5Y0EoAA2pvYl9maWxlX3N0MDFfZmlvX21tYXBfcmFuZHJlYWRfNGsApdrLbtswFIThvV4m
pu4u4HUfoigMJZZdJbZkyEqL9OnrXmbozurwaEcggT/iB0Yrfjmdp+fu/DU7DHP/suw22TD142kY
+93l0l2z2/Cz37Wfs+fbrnzLxvfL63Q/huw8Tdfbrsrm93EZLv2u2Gyy0zy9X/dzf53mZRhP2TB+
787DoVv6+8/+/f1p/tg9Xcbl6bZcn47DdP9jlx2Hc7+/9fP34aXfLx/Xfjd342G6fCrqLPtyB/e3
w3PY396fN1+z29LNy6E/dx/3H51//PnXue8Of35l7O5X+f2bm6dj+PTvkONQ4FDiUOFQ49Dg0Aod
EminiEMQOk+gnSJbCV0k0E6RrYQuE2inyFZCVwm0U2QroesE2imyldBNAu0U2Yr0S9quA8QAMUAM
EAPEADGgVXjc9Uvarv0iDkFo8679IlsJbd61X2Qroc279otsJbR5136RrYQ279ovspXQ5l37RbYi
fUjbdQ4xh5hDzCHmEHOIOVrlj7s+pO3aL+IQhDbv2i+yldDmXftFthLavGu/yFZCm3ftF9lKaPOu
/SJbCW3etV9kK9J92q4LiAXEAmIBsYBYQCzQqnjcdZ+2a7+IQxDavGu/yFZCm3ftF9lKaPOu/SJb
CW3etV9kK6HNu/aLbCW0edd+ka1IH9N2XUIsIZYQS4glxBJiiVbl466Pabv2izgEoc279otsJbR5
136RrYQ279ovspXQ5l37RbYS2rxrv8hWQpt37RfZivQpbdcVxApiBbGCWEGsIFZoVT3u+pS2a7+I
QxDavGu/yFZCm3ftF9lKaPOu/SJbCW3etV9kK6HNu/aLbCW0edd+ka1If0vbdQ2xhlhDrCHWEGuI
NVrVj7v+lrZrv4hDENq8a7/IVkKbd+0X2Upo8679IlsJbd61X2Qroc279otsJbR5136RrUgPabtu
IDYQG4gNxAZiA7FBq+Zx10Parv0iDkFo8679IlsJbd61X2Qroc279otsJbR5136RrYQ279ovspXQ
5l37RbYi/Zq26xZiC7GF2EJsIbYQW7RqH3f9mrZrv4hDENq8a7/IVkKbd+0X2Upo8679IlsJbd61
X2Qroc279otsJbR5136RrUi/pe16C3ELcQtxC3ELcQtxi1bbx12/pe3aL+IQhDbv2i+yldDmXftF
thLavGu/yFZCm3ftF9lKaPOu/SJbCW3etV9kK9LnxHcpfAoT+BYm8DFM4GuYwOcwge9hAp/yhP/e
nZ0T36eshXkKcgX7O5W1cCwoV7C/V1kLx4JyBfu7lbVwLChXsL9fWQvHgnIF+zuWtXAsKFewv2dZ
C8eCvMIl8bsQn9LEtzTxMU18TROf08T3NPEp0H/v1i6J34W1ME9BrmD/LqyFY0G5gv27sBaOBeUK
9u/CWjgWlCvYvwtr4VhQrmD/LqyFY0G5gv27sBaOBbPsF2PElBJBLwAA


--=-EY2VlgPcUzHxOfsdjloT--

