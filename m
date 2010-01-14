Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690Ab0ANADk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab0ANADk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 19:03:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853Ab0ANADi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 19:03:38 -0500
Received: from mail-iw0-f194.google.com ([209.85.223.194]:59824 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab0ANADi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 19:03:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CvSwLUmbYshuIjq/pu9HLnfPAayGftJuE4g7cpjlqbPqGlGkXDp24F2dGfuzhCpWa+
         EaowuYOifyEEKAmjEW7iC62AoOKaJOspSrwDSbTmJ1flWkYkQtP//vySEzIeYe0RDax6
         J/IE+YZqSThr2f40q2c2PQG8G/A53am5qvQoQ=
MIME-Version: 1.0
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF12D391CB2A@orsmsx501.amr.corp.intel.com>
References: <201001121700.18234.seth.heasley@intel.com>
	 <4B4D4EAA.2010109@gmail.com> <4B4DAA68.60608@pobox.com>
	 <4B4DDFD3.5050700@redhat.com>
	 <CF9C39F99A89134C9CF9C4CCB68B8DDF12D391CB2A@orsmsx501.amr.corp.intel.com>
Date: Wed, 13 Jan 2010 18:03:37 -0600
Message-ID: <51f3faa71001131603x56abe9a2t4a8c4ffc3dadfce2@mail.gmail.com>
Subject: Re: [PATCH 2.6.32.3] ahci: AHCI and RAID mode SATA patch for Intel 
	Cougar Point DeviceIDs
From: Robert Hancock <hancockrwd@gmail.com>
To: "Heasley, Seth" <seth.heasley@intel.com>
Cc: David Milburn <dmilburn@redhat.com>, Jeff Garzik <jgarzik@pobox.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 9:43 AM, Heasley, Seth <seth.heasley@intel.com> wrote:
>>> * some of lines of Intel chips do not separate AHCI into a separate PCI
>>> ID rather legacy IDE interface.  When an AHCI interface exists and
>>> AHCI/IDE share the same PCI ID, we default to using AHCI.  Thus, some of
>>> those PCI ID matches in ahci.c's PCI table may not get caught by the
>>> generic PCI class match at the end of the table.
>>>
>>> * the cost carrying redundant PCI IDs seems low, harmless, and
>>> potentially helpful.
>>
>>It is helpful for the specific device IDs to show up in "modinfo ahci" and
>>modules.pcimap.
>>
>>David
>
> This is the reason I was asked to start adding the AHCI DeviceIDs here.

I'm not sure why exactly that is useful - or at least why it's useful
enough to be worth the effort of patching the kernel for every new
AHCI controller that gets released..

I looked at what the Windows msahci driver is doing, they're not
listing any specific device IDs at all, they're just using the class
code matching only. (Of course, they don't have to worry about devices
in RAID mode, as those have to use vendor-specific drivers..)
