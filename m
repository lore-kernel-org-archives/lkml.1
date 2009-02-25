Return-Path: <linux-kernel-owner+w=401wt.eu-S1760797AbZBYX4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760797AbZBYX4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 18:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbZBYX4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 18:56:22 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:31176 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbZBYX4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 18:56:21 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, sandeen@redhat.com
Subject: Re: ATA support for 4k sector size
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1235600698-6446-1-git-send-email-matthew@wil.cx>
	<49A5CBF7.9000501@zytor.com> <yq1hc2iumg9.fsf@sermon.lab.mkp.net>
	<49A5D76A.3010301@zytor.com>
Date: Wed, 25 Feb 2009 18:55:42 -0500
In-Reply-To: <49A5D76A.3010301@zytor.com> (H. Peter Anvin's message of "Wed\, 25 Feb 2009 15\:42\:34 -0800")
Message-ID: <yq11vtmhy0x.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.49A5DA82.0082:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "hpa" == H Peter Anvin <hpa@zytor.com> writes:

>> Because of 63-sector legacy problems a bunch of ATA vendors will
>> initially ship 512/4096 drives that are not naturally aligned.
>> I.e. logical sector 63 will be aligned on a 4KB hardware sector
>> boundary to overcome the misaligned default partitioning.
>> 

hpa> I was under the impression Vista didn't do this?  Is there any way
hpa> to force these drives into a sane mode (at the expense of a total
hpa> data loss)?

Modern Windows aligns the first partition on a 1 MB boundary.

As far as disks go, initially the plan was to have "legacy" branded
drives with 63-sector alignment.  But I think that has been abandoned in
favor of instant one-time formatting.  I.e. you can pick your poison
*once* and that formatting will be done in constant time.  Any
subsequent changes to blocking and alignment will require a real
low-level format.

That's all fine and dandy if you go down and buy a drive a Fry's and
you're the first to use it.  But we don't have that luxury on systems
that come preinstalled with Windows.  In that case we have to deal with
whatever the OEM decided during manufacturing.

IOW, we have to deal with all the possible configurations.

-- 
Martin K. Petersen	Oracle Linux Engineering
