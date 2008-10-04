Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbYJDH3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbYJDH3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 03:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbYJDH3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 03:29:11 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:38969 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbYJDH3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 03:29:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=N6IujH2Nx70ggKdx/RQ9/o9POTnFxfnnPra+OfZcqVlbLAS5kpXAy91S5v0HJJfyO/
         tETLgIO/PI2/WNa+HVdlOoXPYHY5V0d8aZBdIodotBY07XvfkmJ53ptQUsLLgTb2SZwK
         tvJBc6H3IGyTbGueN3oS0p7c0rhNETB4frDrw=
Message-ID: <48E71AEC.8020701@gmail.com>
Date: Sat, 04 Oct 2008 16:27:40 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: gettinther <gettinther@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: sata dvdroms fails to be recognized by MCP55 controller with
 the 2.6.26.5 kernel
References: <64630f150809291601w3511febdyc769b8871db75602@mail.gmail.com>	 <20080930170849.52c00228.akpm@linux-foundation.org>	 <48E2E8A1.8090204@gmail.com>	 <64630f150810010131g18c1a00m91b3f68ea29a1067@mail.gmail.com> <64630f150810011601y4e729decq24c614f0b7994f3f@mail.gmail.com> <48E71ACE.4000505@gmail.com>
In-Reply-To: <48E71ACE.4000505@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(restoring lkml and linux-ide.  please don't drop cc list)

Tejun Heo wrote:
> Hello,
> 
> gettinther wrote:
>> 00:05.2 IDE interface: GeForce 8800 GT 512 MCP55 SATA Controller (rev
>> a2) (prog-if 85 [Master SecO PriO])
> 
> Ah.. okay.  MCP55.  I've missed that part in the first message.
> sata_nv is a bit messed up for 2.6.26.  What happened was...
> 
> * During 2.6.26-rc, libata switched to prefer hardreset over softreset
>   for various reasons.
> 
> * After 2.6.26 release, sata_nv generic flavors (MCP55/66) were
>   reported to have problems probing devices with hardreset.  Hardreset
>   simply doesn't work.
> 
> * Patch posted to disable hardreset for generic but it accidentally
>   disabled hardreset for all flavors (generic/nf2/3/ck804).
> 
> * Which broke ck804.
> 
> * Another patch posted to reinstate hardreset for nf2/3 and ck804.
> 
> * It somehow mysteriously broke nf2/3.  This is still being
>   investigated.
> 
> Sorry about the mess but I am puzzled too.  I'll report back when I
> know more.
> 
> Thanks.
> 


-- 
tejun
