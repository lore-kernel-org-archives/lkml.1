Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752159AbYLRHxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbYLRHxc (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 02:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbYLRHxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 02:53:22 -0500
Received: from rv-out-0506.google.com ([209.85.198.234]:52970 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbYLRHxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 02:53:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=SWwMh1ncS4PWXeKLyofYCsPGNzoFDHnb17IJ/+T1e4mc2HhnG4yC1+W0+Dl/94PrgG
         m34wfjbDXsUheEnPDx0VU9/EJyZwX9M/daZskzhWGRodS28nGjdgDJ9I4/lkZ3XKk02q
         ZMGCaw41dPDqaZvdKwqH9zZ7ZYFg6xMcuU/YM=
Message-ID: <76366b180812172353o4f4fce30taac753a52a2a6e3e@mail.gmail.com>
Date: Thu, 18 Dec 2008 02:53:18 -0500
From: "Andrew Paprocki" <andrew@ishiboo.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: i8k: fails to detect Dell XPS M1530, fails to get SMM BIOS version with force=1
Cc: LKML <linux-kernel@vger.kernel.org>, dz@debian.org,
        "Federico Heinz" <fheinz@vialibre.org.ar>,
        "Andy Spencer" <spenceal@rose-hulman.edu>
In-Reply-To: <20081217222221.ac2c6f3a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <76366b180812171634k6c5a25d6uad0de0d6c514ebb5@mail.gmail.com>
	 <76366b180812171707j7ad58957xf153d40efb7c7d59@mail.gmail.com>
	 <20081217222221.ac2c6f3a.akpm@linux-foundation.org>
X-Google-Sender-Auth: 5ea53086737a1f11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 1:22 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>> The same message prints for (at least one of) those as well:
>>
>> i8k: unable to get SMM BIOS version
>
> hm.  But the driver works OK anyway?

It appears to work.

I tried to figure out why the SMM message is printing out. I can't
find any reference for the #defined values in i8k.c. The only prior
source code I can find mentioning some of them appears to be from the
Windows fanio driver inside the i8kfangui source code
(i8kfangui31-src.zip). Those constants seem to have been reverse
engineered by disassembling the nbsvc.mdm (really an MS-DOS
executable) that Dell puts in the first partition of the laptop hard
drive.

Is there a valid reference for how this SMM mechanism works and what
the inputs/outputs are? There must be some other snippets of code
around because there are a few values in i8k.c which are not in
i8kfangui31-src.zip. I could help with this code if anyone has a
reliable source for this information. The i8kfangui31 source mentions
V1266, and if I strings my copy of nbsvc.mdm, I see V1323. I'm not
sure how this (incomplete) table was derived.

--- begin paste

  According to the module NBSVC.MDM the following SMM (System
Management Mode) functions are currently available (V1266):

  cmd     function
  0x00a3  get current speed indicator of a fan (args: fan)
  0x01a3  set speed of a fan (args: fan & speed)
  0x02a3  get RPM of a fan (args: fan)
  0x03a3  ??? (1 byte)
  0x04a3  get nominal fan speed (2 args)
  0x05a3  get fan tolerance speed (2 args)
  0x10a3  get sensor temperature (1 arg: sensor#)
  0x11a3  ???
  0x12a3  arg 0x0003=NBSVC-Query
          arg 0x0000=NBSVC-Clear
          arg 0x122=NBSVC-Start Trend
          arg 0x0100=NBSVC-Stop Trend
          arg 0x02??=NBSVC-Read
  0x21a3  ??? (2 args: 1 byte (oder 0x16) + 1 byte)
  0x22a3  get charger info (1 arg)
  0x23a3  ??? (4 args: 2x 1 byte, 1xword, 1xdword)
  0x24a3  get adaptor info status (1 arg oder 0x03)
  0x30a3  ??? (no args)
  0x31a3  ??? (no args)
  0x32a3  ??? (no args)
  0x33a3  ??? (no args)
  0x36a3  get hotkey scancode list (args see diags)
  0x37a3  ??? (no args)
  0x40a3  get docking state (no args)
  0xf0a3  ??? (2 args)
  0xfea3  check SMBIOS version (1 arg)
  0xffa3  check SMBIOS interface (returns:"DELLDIAG")
