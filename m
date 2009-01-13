Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZAMP2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZAMP2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 10:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbZAMP2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 10:28:40 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:14345 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751215AbZAMP2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 10:28:38 -0500
Message-ID: <496CB322.8010202@panasas.com>
Date: Tue, 13 Jan 2009 17:28:34 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 3.0a1 (X11/2008050714)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, Jamie Lokier <jamie@shareable.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Boaz Harrosh <bharrosh@panasas.com>,
       open-osd development <osd-dev@open-osd.org>,
       Avishay Traeger <avishay@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [osd-dev] [PATCH 1/9] exofs: osd Swiss army knife
References: <4947BFAA.4030208@panasas.com> <4947C624.3050602@panasas.com> <4964CEA4.7080001@panasas.com> <20090113135526.28730314@lxorguk.ukuu.org.uk> <20090113150955.GA9636@shareable.org> <496CB076.8080002@garzik.org>
In-Reply-To: <496CB076.8080002@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jan 2009 15:28:37.0364 (UTC) FILETIME=[9ABF4B40:01C97593]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan. 13, 2009, 17:17 +0200, Jeff Garzik <jeff@garzik.org> wrote:
> Jamie Lokier wrote:
>> Having one super block would be silly.
> 
> Yep.
> 
> 
>> But aren't most kinds of replication better done behind the OSD level,
>> on the storage fabric?  OSD is all about letting the fabric decide
>> things like allocation and durability strategies after all.
> 
> Probably, but one cannot _assume_ that.  The OSD device might just be a 
> dumb, non-replicated OSD simulator, or in the future, a singleton SATA 
> drive.
> 
> 	Jeff
> 
> 
> 

Alan asked about an _os_ failure.  I consider it different than a disk
level failure which is typically handled by RAID.  At the OS level I'd
care more about the self consistency of the metadata and its corruption
due to the OS (or the OSD) failing to update it atomically.
In exofs's case the metadata in superblock is unexpensive to recover.
It holds the last object ID created.  If, when using it, the filesystem
finds an already existing object it can detect the last object created
using a logarithmic search (or even a linear one assuming the sb is
synced frequently enough).  Therefore I wouldn't spend cycles on
replicating it.

Benny


