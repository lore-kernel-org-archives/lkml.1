Return-Path: <linux-kernel-owner+w=401wt.eu-S1751042AbXDCUwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751042AbXDCUwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 16:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945937AbXDCUwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 16:52:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:55202 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbXDCUwP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 16:52:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: A set of "standard" virtual devices?
Date: Tue, 3 Apr 2007 22:50:19 +0200
User-Agent: KMail/1.9.6
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Andi Kleen <ak@suse.de>,
       Christian Borntraeger <borntrae@de.ibm.com>,
       virtualization@lists.linux-foundation.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
References: <4611652F.700@zytor.com> <200704032142.51976.arnd@arndb.de> <4612B123.2040105@goop.org>
In-Reply-To: <4612B123.2040105@goop.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704032250.19875.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19pp+O0mQt38n9A6B9inVkIKtpgEl7qYJcw0DG
 twk6i+37GmAuFurfNVNqArIMOfG3u0F/aaHdhfX9hEw7StThDA
 tCdMBbq/kLdluWF7cMsGA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 April 2007, Jeremy Fitzhardinge wrote:
> > Doing a SCSI driver has been tried before, with ibmvscsi. Not good.
> >   
> 
> OK, interesting.  People had proposed using SCSI as the interface, but I
> wasn't aware of any results from doing that.  How is it not good?
> 

SCSI is really overengineered for something as simple as a block interface.
A large part of the SCSI stack deals only with error handling, which
you don't want to burden the guests with at all, since most error conditions
can be handled fine by the host.
Another big aspect of SCSI is device enumeration and probing. Doing it
the SCSI way is particularly pointless. It's much simpler to have one
device with its own I/O interface at the hcall layer, and one interrupt
number for the block device, instead of faking the full hca/bus/dev/lun
hierarchy.

	Arnd <><
