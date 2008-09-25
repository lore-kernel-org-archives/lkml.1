Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbYIYVGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbYIYVGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 17:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbYIYVG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 17:06:27 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:51265 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbYIYVGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 17:06:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xyFo06vlUFryxn2fsdkDKmyGbrwqHQZqlXWrlxbXEzefGXGbIVi7TJE1J8nNpDHVrd
         /rIDzGSXISHmMFsLP0dhEKJMJu3AdpeaIZdmMrDFS7biEL4YOhQVF429UlWUyR9sMRxH
         1j7TuttF30Lg8f6IJNtdUdeTRlMweufvlxgO4=
Message-ID: <21d7e9970809251406gb2bdacbuf9ff1bde3d118cdb@mail.gmail.com>
Date: Fri, 26 Sep 2008 07:06:23 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>, "Frans Pop" <elendil@planet.nl>,
       "Jeff Garzik" <jeff@garzik.org>, davem@davemloft.net,
       jeffrey.t.kirsher@intel.com, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com, "Ingo Molnar" <mingo@elte.hu>,
       jesse.brandeburg@gmail.com
In-Reply-To: <alpine.LNX.1.10.0809252234400.3389@pegasus.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080923.150722.141587696.davem@davemloft.net>
	 <200809251156.10648.jbarnes@virtuousgeek.org>
	 <alpine.LNX.1.10.0809252218470.3389@pegasus.suse.cz>
	 <200809251236.12287.jbarnes@virtuousgeek.org>
	 <alpine.LNX.1.10.0809252234400.3389@pegasus.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 6:35 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Thu, 25 Sep 2008, Jesse Barnes wrote:
>
>> However, the "Factory" log at #425480 *does* indicate that a GEM aware
>> 2D driver was loaded (the "[drm:i915_getparam] *ERROR* Unknown parameter
>> 5" message indicates as much), but the kernel was definitely not GEM
>> aware otherwise the call would have succeeded.  So that rules out GEM
>> proper, but it could still be a bug in one of the non-GEM paths in the
>> experimental xf86-video-intel bits the various distros seem to be
>> picking up.
>
> That was exactly the point I was trying to make, that these error paths
> will probably also need auditing, once we rule out the possibility of
> NVRAM being overwritten from kernelspace.
>

Well the non-GEM paths are really the old codepaths we used in the
older drivers..

So unless we do something really dumb...

I'd target three areas PAT, pciaccess and e1000e itself.

Dave.
