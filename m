Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbZHULFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbZHULFM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 07:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbZHULFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 07:05:11 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:44768 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbZHULFK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 07:05:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CGTHW7bpVCrWdkXx04iRAGUw/usU9Me4nSwjjTmOcTDmUwcaB5fi3VOm8h+Eadcvj/
         GnFSiJON9bqApym9ftUzZzuf4iFQkek8JHtHsBekCr6VsnVi+agsDDCzDpL53xr7ENm6
         Q975xfCJm1b5HKrHk/aGyLAa8femwXrTC22h0=
MIME-Version: 1.0
In-Reply-To: <20090728164520.GB13662@gradator.net>
References: <ct4xS-63o-27@gated-at.bofh.it>
	 <ba6a8e0d-946b-4d69-9f70-991e93c18f90@o15g2000yqm.googlegroups.com>
	 <20090728164520.GB13662@gradator.net>
Date: Fri, 21 Aug 2009 12:05:10 +0100
Message-ID: <6278d2220908210405n35778e04mc1728f2c37ef0c0f@mail.gmail.com>
Subject: Re: 2.6.28.9: EXT3/NFS inodes corruption
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Sylvain Rochet <gradator@gradator.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylvain,

On Tue, Jul 28, 2009 at 5:45 PM, Sylvain Rochet<gradator@gradator.net> wrote:
> On Tue, Jul 28, 2009 at 09:40:42AM -0700, Daniel J Blueman wrote:
>> On Apr 20, 5:30 pm, Sylvain Rochet <grada...@gradator.net> wrote:
>> > Hi,
>> >
>> > We(TuxFamily) are having some inodes corruptions on a NFS server.
>> >
>> > So, let's start with the facts.
>> >
>> > ==== NFS Server
>> >
>> > Linux bazooka 2.6.28.9 #1 SMP Mon Mar 30 12:58:22 CEST 2009 x86_64 GNU/Linux
>> [snip]
>>
>> Can you do a 'lspci -v' on the server please?
>
> Of course yes.
>
> I attached the 'lspci -v' of the previous and the current storage
> server.

The reason I ask, I was chasing data corruption across the PCIe bus
with some high-performance Quadrics interconnect adapters a while ago.
The reproducer involved multiple outstanding main memory read requests
to related addresses and a small block of data would be returned from
the wrong offset.

In the end, I found the nVidia CK804 (also MCP55) HT->PCIe bridge was
at fault and later found disk corruption when doing heavy rsyncs to
network. This was never publicly acknowledged, but I guess it
illustrates the need for some micro-tests to verify data-soundness
under duress; it took a day (and petabytes of data) of the production
I/O workload to get this data corruption, and 3 seconds with the right
reproducer, (still non-trivial to catch on a PCIe protocol analyser).

Sometime I'll develop a stress-test driver for a common SATA or
network controller to drive it's DMA engine with I/O patterns to and
from main memory, checking the data integrity every few seconds; this
could be generalised with OpenGL nicely for graphics cards on
workstations I imagine.

Daniel
-- 
Daniel J Blueman
