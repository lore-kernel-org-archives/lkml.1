Return-Path: <linux-kernel-owner+w=401wt.eu-S1753533AbZKUU6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbZKUU6k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 15:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbZKUU6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 15:58:39 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:55078 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbZKUU6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 15:58:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=MH6oC5xdw783qM7hXCz2E2Ukv/ADXZ20wuht76vslbASYE8fjmHclStY3ovk0Kj7WC
         BQMz6/rGOGcrWwGyZz+WPsjyvpazc/8vij8yEFlyJf2NCUUHKPdbmYSW67PJezRXm3ww
         kuYtZcTxAXCppHSX7uDBcHZTSM+p8J+Ez+qMA=
MIME-Version: 1.0
In-Reply-To: <20091121203645.60d68d11@mjolnir.ossman.eu>
References: <20091008163952.679572b5@mjolnir.ossman.eu>
	 <20091121170355.7540d169@mjolnir.ossman.eu>
	 <e9c3a7c20911211121l517837f9s17283dd37e0dd865@mail.gmail.com>
	 <20091121203645.60d68d11@mjolnir.ossman.eu>
Date: Sat, 21 Nov 2009 13:58:41 -0700
X-Google-Sender-Auth: b68f9143b9009f36
Message-ID: <e9c3a7c20911211258r756e044cpad5ae9d613284f8b@mail.gmail.com>
Subject: Re: Raid not shutting down when disks are lost?
From: Dan Williams <dan.j.williams@intel.com>
To: Pierre Ossman <pierre-list@ossman.eu>
Cc: neilb@suse.de, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 21, 2009 at 12:36 PM, Pierre Ossman <pierre-list@ossman.eu> wrote:
> Or is there perhaps some magic mdadm command to add a lost disk and get
> it up to speed without a complete sync?

If you care about resync speed then look into adding a write intent
bitmap to your configuration; otherwise, look into the --assume-clean
option to recreate the array.

Quoting from the man page:
--assume-clean
     Tell mdadm that the array pre-existed and is known to be clean.
It can be useful when trying to recover from a major failure as you
can be sure that no data will be affected unless you actually write to
the array.  It can also be used when creating a RAID1 or RAID10 if you
want to avoid the initial resync, however this practice, while
normally safe, is not recommended.  Use this only if you really know
what you are doing.

--
Dan
